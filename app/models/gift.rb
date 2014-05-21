class Gift < ActiveRecord::Base
  belongs_to :gifter, class_name: "User"
  belongs_to :giftee, class_name: "User"

  belongs_to :group

  validates :gifter_id, :giftee_id, :group_id, presence: true
  scope :alphabetize, -> { order('name') }
  
  def self.pull_from_hat(options={})
    date = options[:date] 
    no_output = options[:no_output]
    hit_rescue = false

    unless no_output
    time1 = Time.now() #for timer
      puts "======================================================================"
      puts "Pulling From Hat"
    end
    
    date ||= Time.now.to_date 
    ActiveRecord::Base.transaction do
      groups = Group.where(select_date: date).to_a

      groups.each do |group|
        Gift.destroy_all(group_id: group.id)
        
        unused_ids = group.user_ids.sort
        last_id = unused_ids.last

        group.user_ids.sort.each do |gifter_id|
          begin
            giftee_id = self.unpicked_giftee_id(unused_ids, gifter_id, last_id)
            unused_ids -= [giftee_id]
            Gift.create(gifter_id: gifter_id, giftee_id: giftee_id, group_id: group.id)
          rescue Error
            unused_ids = group.user_ids
            hit_rescue = true
            retry
          end
        end
      end
    end

      unless no_output
        time2 = Time.now() #for timer
        puts "======================================================================"
        puts "hit system stack error rescue" if hit_rescue
        puts "pulled_from_hat completed #{Time.now.strftime('on %m/%d/%Y at %I:%M%p')} in #{time2 - time1} seconds"
        puts "======================================================================"
      end
    hit_rescue
  end


  def self.unpicked_giftee_id(unused_ids, gifter_id, last_id)
    # return SystemStackError if unused_ids.length == 1 && gifter_id == unused_ids[0]    
    return last_id if unused_ids.length == 2 && unused_ids.include?(last_id)
      
    # returns a random id unless it is the gifter_id
    giftee_position = rand(unused_ids.length-1)
    giftee_id = unused_ids[giftee_position]
    if giftee_id == gifter_id 
      self.unpicked_giftee_id(unused_ids, gifter_id, last_id)
    else 
      return giftee_id
    end
  end
end

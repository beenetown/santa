class Gift < ActiveRecord::Base
  belongs_to :gifter, class_name: "User"
  belongs_to :giftee, class_name: "User"

  belongs_to :group

  validates :gifter_id, :giftee_id, :group_id, presence: true
  scope :alphabetize, -> { order('name') }
  
  def self.pull_from_hat(options={})
    time1 = Time.now() #for timer
    date = options[:date] 
    no_output = options[:no_output]

    unless no_output
      puts "======================================================================"
    end
    
    date ||= Time.now.to_date 
    groups = Group.where(select_date: date).to_a

    groups.each do |group|

      Gift.destroy_all(group_id: group.id)
      
      unused_ids = group.user_ids
      group.users.each do |gifter|
        begin
          gifter_id = gifter.id
          giftee_id = self.unpicked_giftee_id(unused_ids, gifter_id)
          unused_ids -= [giftee_id]

          Gift.create(gifter_id: gifter.id, giftee_id: giftee_id, group_id: group.id)
        rescue SystemStackError
          puts "hit system stack error rescue"
          unused_ids = group.user_ids
          retry
            # self.pull_from_hat
        end
      end
    end
      time2 = Time.now() #for timer
      unless no_output
        puts "pulled_from_hat completed #{Time.now.strftime('on %m/%d/%Y at %I:%M%p')} in #{time2 - time1} seconds"
        puts "======================================================================"
      end
  end

  def self.unpicked_giftee_id(unused_ids, gifter_id)
    # return gifter_id if gifter_id == unused_ids[0] && unused_ids.length == 1
    giftee_position = rand(unused_ids.length)
    giftee_id = unused_ids[giftee_position]
    if giftee_id == gifter_id #|| used_ids.include?(giftee_id)
      self.unpicked_giftee_id(unused_ids, gifter_id)
    else 
      return giftee_id
    end
  end
end

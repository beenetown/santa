require 'spec_helper'

describe Group do
  let(:group_owner) { FactoryGirl.create(:user)}
  let(:owner_auth) { FactoryGirl.create(:auth, user_id: group_owner.id) }
  let(:giftee) { FactoryGirl.create(:user) }
  let(:gifter) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, owner_id: group_owner.id) }
  
  let!(:invite_1) { FactoryGirl.create(:invite, group_id: group.id) }
  let!(:invite_2) { FactoryGirl.create(:invite, group_id: group.id) }
  let!(:gift_1) { FactoryGirl.create(:gift, group_id: group.id, gifter_id: gifter.id, giftee_id: giftee.id)}
  let!(:gift_2) { FactoryGirl.create(:gift, group_id: group.id, gifter_id: giftee.id, giftee_id: gifter.id)}

  subject { group }

  it { should respond_to :owner_id }
  it { should respond_to :owner }
  it { should respond_to :select_date }  
  it { should respond_to :open_date }
  it { should respond_to :invites }
  it { should respond_to :users }
  it { should respond_to :memberships }
  it { should respond_to :gifts }
  it { should respond_to :users }

  it { should be_valid }

  describe "invites" do
    it "should be destroyed when group is destroyed" do
      invites = group.invites.to_a
      group.destroy
      expect(invites).not_to be_empty
      invites.each do |invite|
        expect(Invite.where(id: invite.id)).to be_empty
      end
    end
  end

  describe "gifts" do
    it "should be destroyed when group is destroyed" do
      gifts = group.gifts.to_a
      group.destroy
      expect(gifts).not_to be_empty
      gifts.each do |gift|
        expect(Gift.where(id: gift.id)).to be_empty
      end
    end
  end  

  describe "membership relation" do
    before { group.users = [group_owner, gifter, giftee] }
    it "should be destroyed when group is destroyed" do
      memberships = group.memberships.to_a
      group.destroy
      expect(memberships).not_to be_empty
      memberships.each do |membership|
        expect(Membership.where(id: membership.id)).to be_empty
      end
    end
  end  
end
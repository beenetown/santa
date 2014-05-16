require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let!(:auth_1) { FactoryGirl.create(:auth, user_id: user.id) }
  let!(:auth_2) { FactoryGirl.create(:auth, provider: "google", email: "google@example.com", user_id: user.id) }

  let(:giftee) { FactoryGirl.create(:user) }
  let(:gifter) { FactoryGirl.create(:user) }

  let!(:group_1) { FactoryGirl.create(:group) }
  let!(:group_2) { FactoryGirl.create(:group) }
  let!(:invite_1) { FactoryGirl.create(:invite, group_id: group_1.id, user_id: user.id) }
  let!(:invite_2) { FactoryGirl.create(:invite, group_id: group_2.id, user_id: user.id) } 
  let!(:gift_1) { FactoryGirl.create(:gift, group_id: group_1.id, gifter_id: user.id, giftee_id: giftee.id)}
  let!(:gift_2) { FactoryGirl.create(:gift, group_id: group_2.id, gifter_id: user.id, giftee_id: gifter.id)} 

  subject { user }

  it { should respond_to :admin }
  it { should respond_to :guest }

  it { should respond_to :groups }
  it { should respond_to :memberships }
  it { should respond_to :gifts }
  it { should respond_to :received_gifts }
  it { should respond_to :gifters }
  it { should respond_to :giftees }

  it { should respond_to :auths }

  it { should be_valid }

  describe "memberships" do
    before { user.groups = [group_1, group_2] }

    it "should be destroyed when group is destroyed" do
      memberships = user.memberships.to_a
      user.destroy
      expect(memberships).not_to be_empty
      memberships.each do |membership|
        expect(Membership.where(id: membership.id)).to be_empty
      end
    end
  end

  describe "invites" do
    before { user.invites = [invite_1, invite_2] }

    it "should be destroyed when group is destroyed" do
      invites = user.invites.to_a
      user.destroy
      expect(invites).not_to be_empty
      invites.each do |invite|
        expect(Invite.where(id: invite.id)).to be_empty
      end
    end
  end

  describe "gifts" do
    before { user.gifts = [gift_1, gift_2] }

    it "should be destroyed when gift is destroyed" do
      gifts = user.gifts.to_a
      user.destroy
      expect(gifts).not_to be_empty
      gifts.each do |gift|
        expect(Gift.where(id: gift.id)).to be_empty
      end
    end
  end

  describe "auths" do
    before { user.auths = [auth_1, auth_2] }

    it "should be destroyed when auth is destroyed" do
      auths = user.auths.to_a
      user.destroy
      expect(auths).not_to be_empty
      auths.each do |auth|
        expect(Auth.where(id: auth.id)).to be_empty
      end
    end
  end

  describe "view_name" do
    it "should return the right view name" do
      expect(user.view_name).to eq auth_1.name
    end
  end
end


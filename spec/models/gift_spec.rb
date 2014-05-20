require 'spec_helper'

describe Gift do
  let(:gift) { FactoryGirl.create(:gift, giftee_id: 1, gifter_id: 2, group_id: 1) }
  subject { gift }

  it { should respond_to :gifter_id }
  it { should respond_to :giftee_id }
  it { should respond_to :group_id }
  it { should respond_to :gifter }
  it { should respond_to :giftee }
  it { should respond_to :group }

  it { should be_valid }
  
  #validation tests
  describe "without a gifter" do
    let(:gift_without_gifter) { FactoryGirl.build(:gift, giftee_id: 1, group_id: 1) }
    subject { gift_without_gifter }
    it { should_not be_valid }
  end

  describe "without a giftee" do
    let(:gift_without_giftee) { FactoryGirl.build(:gift, gifter_id: 1, group_id: 1)}
    subject { gift_without_giftee }
    it { should_not be_valid }
  end

  describe "without a group" do
    let(:gift_without_group) { FactoryGirl.build(:gift, gifter_id: 1, giftee_id: 2)}
    subject { gift_without_group }
    it { should_not be_valid }
  end

  describe "pull_from_hat" do
  @group_1 = Group.create(name: "Test Group 1")
  
  @user_1 = User.create()
  @user_2 = User.create()
  @user_3 = User.create()
  @user_4 = User.create()
  

    # let!(:group_1) { FactoryGirl.create(:group, name: "Test Group_1") }
    # let!(:group_2) { FactoryGirl.create(:group, name: "Test Group_2") }
    # let!(:group_3) { FactoryGirl.create(:group, name: "Test Group_3") }

    # let!(:user_1) { FactoryGirl.create(:user) }
    # let!(:user_2) { FactoryGirl.create(:user) }
    # let!(:user_3) { FactoryGirl.create(:user) }
    # let!(:user_4) { FactoryGirl.create(:user) }
    # let!(:user_5) { FactoryGirl.create(:user) }
    # let!(:user_6) { FactoryGirl.create(:user) }
    # let!(:user_7) { FactoryGirl.create(:user) }
    # let!(:user_8) { FactoryGirl.create(:user) }
    # let!(:user_9) { FactoryGirl.create(:user) }
    # let!(:user_10) { FactoryGirl.create(:user) }
    # let!(:user_11) { FactoryGirl.create(:user) }
    # let!(:user_12) { FactoryGirl.create(:user) }

    @group_1.users = [@user_1, @user_2, @user_3, @user_4]
    # group_2.users = [user_5, user_6, user_7, user_8]
    # group_3.users = [user_9, user_10, user_11, user_12]
  end
end
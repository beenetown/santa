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
end
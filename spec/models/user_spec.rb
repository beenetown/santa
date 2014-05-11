require 'spec_helper'

describe User do
  before { @user = User.new(username: "Example", password: "password") } 
    
  subject { @user }

  it { should respond_to :username }
  it { should respond_to :password }
  it { should respond_to :guest }

  it { should be_valid }

  describe "when username is not present" do
    before { @user.username = "" }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = "" }
    it { should be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when username is already taken" do
    before do
      user2 = @user.dup
      user2.save
    end
    it { should_not be_valid }
  end
end
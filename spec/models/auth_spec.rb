require 'spec_helper'

describe Auth do
  before do
    @auth  = Auth.new(name: "test user_id", 
                      email: "testuser@example.com", 
                      password: "password", 
                      password_confirmation: "password" )
  end
  subject { @auth }

  it { should respond_to :provider }
  it { should respond_to :uid }
  it { should respond_to :name }
  it { should respond_to :user_id }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_digest }
  it { should respond_to :third_party }

  it { should respond_to :user }

  it { should be_valid }

  # password validation
  describe "when password is not present" do
    before do
      @auth = Auth.new(name: "test user", 
                      email: "testuser@example.com", 
                      password: " ", 
                      password_confirmation: " " )
    end

    it { should_not be_valid }
  end

  describe "password/password_confirmation mismatch" do
    before do 
      @auth.password = "password"
      @auth.password_confirmation = "mismatch" 
    end

    it { should_not be_valid }
  end

  # Password tests
  describe "return value of authenticate method" do
    before { @auth.save }
    let(:found_user) { Auth.find_by(email: @auth.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@auth.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

    describe "with a password that's too short" do
      before { @auth.password = @auth.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end
  end

  # Email validation tests
  describe "when email is not present" do
    before { @auth.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@example..com user@foo,com user_at_foo.org example.user@foo foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @auth.email = invalid_address
        expect(@auth).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @auth.email = valid_address
        expect(@auth).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @auth.dup
      user_with_same_email.email = @auth.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe " email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPLe.com" }

    it "should be saved as all lower-case" do
      @auth.email = mixed_case_email
      @auth.save
      expect(@auth.reload.email).to eq mixed_case_email.downcase
    end
  end
end
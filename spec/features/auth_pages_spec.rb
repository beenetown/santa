require 'spec_helper'

describe "Auth pages" do
  # let(:auth) { FactoryGirl.create(:auth) }
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector "h1", "Create Your Account:" }
    it { should have_selector ".form" }

    describe "with invalid info" do
      it "should not create an Auth" do
        expect { click_button "Create Account" }.not_to change(Auth, :count)
      end
    end

    describe "with valid info" do
      before do 
        fill_in "auth_name", with: "test user"
        fill_in "auth_email", with: "test_user@example.com"
        fill_in "auth_password", with: "password"
        fill_in "auth_password_confirmation", with: "password"
      end

      it "should create an Auth" do
        expect { click_button "Create Account" }.to change(Auth, :count).by(1)
        expect(page).to have_selector "h1", "test user"
      end
    end
  end
end
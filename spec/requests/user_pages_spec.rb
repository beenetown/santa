require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector "h1", "Sign Up" }
    it { should have_selector "form" }

    describe "with invalid info" do
      it "should not create an Auth" do
        expect { click_button "Create Account" }.not_to change(Auth, :count)
      end
    end

    describe "with valid info" do
      before do 
        within '.form' do
          fill_in "auth_email", with: "test_user@example.com"
          fill_in "auth_password", with: "password"
          fill_in "auth_password_confirmation", with: "password"
        end
      end

      it "should create an Auth" do
        expect { click_button "Create Account" }.to change(Auth, :count).by(1)
      end
    end
  end

  describe "edit-settings page" do
  end
end
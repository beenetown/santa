require 'spec_helper'
describe "static pages" do
  let(:user) { FactoryGirl.create(:user)}
  let(:user_2) { FactoryGirl.create(:user) }
  let(:auth) { FactoryGirl.create(:auth, user_id: user.id)}
  let(:auth_2) { FactoryGirl.create(:auth, user_id: user_2.id, email: "user2@example.com") }
  let(:group) { FactoryGirl.create(:group) }

  
  subject { page }

  describe "Home page" do
    before { visit root_path }
    
    describe "when signed out" do
      it { should have_content('Have a secret santa group?') }
      it { should have_button "Sign Up" }
      it { should have_link "sign in"}
    end

    describe "when signed in" do
      before do
        group.users = [user, user_2]
        Gift.pull_from_hat no_output: true, date: Time.new(2014, 11, 30).to_date
        signin auth
        visit root_path
      end

      it { should have_selector 'h1', text: auth.name }
      it { should have_selector 'h2', text: "Groups" }
      it { should have_selector 'h2', text: "Get a gift for:" }
      it { should have_selector 'li', text: auth_2.name }
      it { should have_selector 'h2', text: "Gift Lists" }
    end
  end

  describe "help page" do
    before { visit help_path }

    it { should have_selector 'h1', text: "Help" }
    it { should have_content "This app is designed to make it easy" }
  end
end
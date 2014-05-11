require 'spec_helper'

describe "static pages" do
  subject { page }

  describe "Home page" do

    describe "GET /" do
      before { visit root_path }

      it { should have_content('Have a secret santa group?') }
      it { should have_button "Sign Up" }
      # pendi ng it { should have_link "try it out", href: "#" }
    end
  end

  it "should have the right links in the layout" do
    visit root_path
    # click_link "Sign up"
    find('#show-nav').click
    expect(page).to have_selector '#nav'
    # expect(page).to have_content 'Enter Your Info'
    # click_link "Home"
    # expect(page).to have_content 'Boring Task App'
    # click_link 'Sign in'
    # expect(page).to have_content 'Sign In'
  end
end

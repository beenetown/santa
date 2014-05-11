require 'spec_helper'

describe "Home page" do
  subject { page }
  before { visit root_path }
  
  describe "GET /" do
    it { should have_content('Have a secret santa group?') }
    it { should have_button "Sign Up" }
  end
end

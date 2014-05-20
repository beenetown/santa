require 'spec_helper'

describe "Auth pages" do
  let(:user) { FactoryGirl.create(:user) }
  let(:auth) { FactoryGirl.create(:auth, user_id: user.id) }
  let(:incorrect_user) { FactoryGirl.create(:user) }
  let(:incorrect_auth) { FactoryGirl.create(:auth, user_id: incorrect_user.id, 
                                                   name: "Incorrect User", 
                                                   email: "incorrect@example.com"
                                                   )} 

  subject { page }

  describe "signup/new page" do
    before { visit signup_path }

    it { should have_selector "h1", "Create Your Account:" }
    it { should have_selector ".form" }

    describe "with invalid info" do
      it "should not create an Auth" do
        expect { click_button "Create Account" }.not_to change(Auth, :count)
        expect(page).to have_selector '#alert', text: "5 errors prohibited this from being saved:"
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

  describe "edit page" do
    describe "when not signed in" do
      before { visit edit_user_auth_path(user, auth) }

      it { should_not have_content "Update #{auth.provider.capitalize} Account" }
      it { should have_selector '#alert', text: "You don't have access to that!" }
    end

    describe "when signed in as correct user" do
      before do
        signin auth
        visit edit_user_auth_path(user, auth)
      end

      it { should have_selector 'h1', text: "Update #{auth.provider.capitalize} Account" }
      it { should have_selector '.form' }
      it { should have_selector '#auth_name' }
      it { should have_selector "#auth_email" }
      it { should have_selector "#auth_password" }
      it { should have_selector "#auth_password_confirmation" }       
      it { should have_selector "input[type='submit'][value='Update Account']"}
      
      describe "with valid info" do
        before do
          signin auth
          visit edit_user_auth_path(user, auth)
        end

        describe "should change auth" do
          before do 
            fill_in 'auth_name', with: "Changed Name"
            fill_in "auth_email", with: "changed_email@example.com"
            fill_in "auth_password", with: "changedpassword"
            fill_in "auth_password_confirmation", with: "changedpassword"
            click_button "Update Account" 
          end

          it { should have_selector "#notice", text: "Account was successfully updated." }
          it { should have_selector "h1", text: "Changed Name" }
          
          describe "changed auth" do
            let(:changed_auth) { Auth.find(auth.id) }
            subject { changed_auth }
            
            its(:name) { should eq "Changed Name"}
            its(:email) { should eq "changed_email@example.com" }
          end
        end
      end 

      describe "with invalid info" do
        before do 
          signin auth
          visit edit_user_auth_path(user, auth)
          fill_in 'auth_name', with: ""
          fill_in "auth_email", with: ""
          fill_in "auth_password", with: ""
          fill_in "auth_password_confirmation", with: ""
          click_button "Update Account" 
        end      

        it { should_not have_selector "#notice", text: "Account was successfully updated." }
        it { should_not have_selector "h1", text: "Changed Name" }
      end
    end

    describe "when signed in as incorrect user" do
      before do
        signin incorrect_auth
        visit edit_user_auth_path(user, auth)
      end       

      it { should have_selector '#alert', text: "You don't have access to that!"}
      it { should have_selector 'h1', text: incorrect_auth.name }

      it { should_not have_selector 'h1', text: "Update #{auth.provider.capitalize} Account" }
      it { should_not have_selector '.form' }
      it { should_not have_selector '#auth_name' }
      it { should_not have_selector "#auth_email" }
      it { should_not have_selector "#auth_password" }
      it { should_not have_selector "#auth_password_confirmation" }       
      it { should_not have_selector "input[type='submit'][value='Update Account']"}
    end
  end

  describe "index page" do
    describe "when not signed in" do
      before { visit user_auths_path(user) }

      it { should_not have_selector 'h1', text: "#{user.view_name}" }
      it { should have_selector '#alert', text: "You don't have access to that!" }
    end

    describe "when signed in as correct user" do
      before do
        signin auth
        visit user_auths_path(user)
      end

      it { should_not have_selector '#alert', text: "Please sign in!" }
      it { should have_selector 'h1', text: "#{auth.name}" }
      it { should have_content "Which would you like to edit?" }
      it { should have_css "img[src*='social_buttons/santa_32.png']"  }
    end
    
    describe "when signed in as incorrect user" do
      before do
        signin incorrect_auth
        visit user_auths_path(user)
      end

      it { should have_selector '#alert', text: "You don't have access to that!"}
      it { should have_selector 'h1', text: incorrect_auth.name }
     
      it { should_not have_selector 'h1', text: "#{auth.name}" }
      it { should_not have_content "Which would you like to edit?" }
      it { should_not have_css "img[src*='social_buttons/santa_32.png']"  }
    end
  end
end
require 'spec_helper'

describe "group pages" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:auth) { FactoryGirl.create(:auth, user_id: user.id) }

  let(:group_user_1) { FactoryGirl.create(:user)}
  let!(:auth_1) { FactoryGirl.create(:auth, user_id: group_user_1.id , name: "Group User 1", email: "user_1@example.com")}

  let(:group_user_2) { FactoryGirl.create(:user)}
  let!(:auth_2) { FactoryGirl.create(:auth, user_id: group_user_2 , name: "Group User 2", email: "user_2@example.com")}

  let(:group_user_3) { FactoryGirl.create(:user)}
  let!(:auth_3) { FactoryGirl.create(:auth, user_id: group_user_3 , name: "Group User 3", email: "user_3@example.com")}

  let(:group) { FactoryGirl.create(:group, owner_id: user.id) }
  before { group.users = [user, group_user_1, group_user_2, group_user_3] }  

  let(:unset_select_date_group) { FactoryGirl.create(:group, name: "Unset Select Date", 
                                                             owner_id: user.id, 
                                                             select_date: nil
                                                             )}
  let(:unset_open_date_group) { FactoryGirl.create(:group, name: "Unset Open Date", 
                                                           owner_id: user.id, 
                                                           open_date: nil
                                                           )}
  let(:unset_spending_limit_group) { FactoryGirl.create(:group, name: "Unset Open Date", 
                                                           owner_id: user.id, 
                                                           spending_limit: nil
                                                           )}
  
  let(:incorrect_user) { FactoryGirl.create(:user) }
  let(:incorrect_auth) { FactoryGirl.create(:auth, user_id: incorrect_user.id, 
                                                   name: "Incorrect User", 
                                                   email: "incorrect@example.com"
                                                   )} 
  
  subject { page }

  describe "edit" do 
    describe "when not signed in" do
      before { visit edit_group_path(group) }

      it { should_not have_selector "h1", text: "Edit #{group.name}"}
      it { should have_selector "#alert", text: "Please sign in!" }
    end
    
    describe "when signed in as correct user" do
      before do
        signin auth
        visit edit_group_path(group)
      end

      it { should_not have_selector "#alert" }
      it { should have_selector "h1", text: "Edit #{group.name}" }
      # it { should have_selector "label", text: "Name" }
      it { should have_selector "#group_name" }
      it { should have_selector "input[type='submit'][value='Update Group']"}
     

      describe "with valid info" do
        before do
          fill_in 'group_name', with: "changed name"
          click_button "Update Group"
        end

        it { should have_selector "#notice", text: "Group was successfully updated." }
        it { should have_selector "h1", text: "changed name"}

        describe "changed group" do
          let(:changed_group) { Group.find(group.id) }
          subject { changed_group }

          its(:name) { should eq "changed name" }
        end
      end

      describe "with invalid info" do
        before do
          fill_in 'group_name', with: ""
          click_button "Update Group"
        end

        it { should_not have_selector "#notice", text: "Group was successfully updated." }
        it { should_not have_selector "h1", text: "changed name"}
        it { should have_selector "#alert", text: "1 error prohibited this from being saved:"}

        describe "group data should not change" do
          let(:unchanged_group) { Group.find(group.id) }
          subject { unchanged_group }

          its(:name) { should_not eq "" }
          its(:name) { should eq "Test Group" }
        end
      end
    end

    describe "when signed in as incorrect user" do
      before do
        signin incorrect_auth
        visit edit_group_path(group)
      end

      it { should_not have_selector "h1", text: "Edit #{group.name}"}
      it { should have_selector "#alert", text: "You don't have access to that!" }

      it { should_not have_selector "h1", text: "Edit #{group.name}" }
      it { should_not have_selector "label", text: "Name" }
      it { should_not have_selector "#group_name" }
      it { should_not have_selector "input[type='submit'][value='Update Group']"}
    end
  end

  describe "index" do
    before { visit groups_path }

    it { should have_selector 'h1', text: "All Groups" }
    it { should have_selector 'ul' }
  end

  describe "new" do
    describe "when not signed in" do
      before { visit new_group_path }

      it { should have_selector '#alert', text: "Please sign in!" }
      it { should have_selector '.hero' }
      it { should_not have_selector 'h1', text: "New group"}
    end

    describe "when signed in" do
      before do
        signin auth 
        click_button "Start New Group" 
      end

      it "clicks Start New Group Button" do
        expect(page).to have_selector 'h1', text: auth.name #need to figure out js driver
        expect(page).to have_selector '#group_name' 
        expect(page).to have_selector '#group_owner_id' 
        expect(page).to have_selector "input[type='submit'][value='Create Group']"
      end

      describe "with invalid info" do
        it "should not be able to create a group" do
          expect { click_button "Create Group" }.not_to change(Group, :count)
          expect(page).to have_selector '#alert', text: "1 error prohibited this from being saved:"
        end
      end

      describe "with valid info" do
        before { fill_in 'group_name', with: "Newly Created Group" }
        
        it "is able to create a new group" do
          expect { click_button "Create Group" }.to change(Group, :count).by(1)
          expect(page).to have_selector 'h1', text: "Newly Created Group"
        end
      end
    end
  end

  describe "show" do
    before { visit group_path(group) }
    
    it { should have_selector 'h1', text: group.name }
    
    describe "when not signed in" do
      it { should_not have_link 'Edit', href: edit_group_path(group)}
      it { should_not have_selector 'label', text: 'Invite a User' }
      it "should not have selector #email" do
        within '.container' do
          expect(page).not_to have_selector "#email"
        end
      end

      describe "with spending limit set" do
        it { should_not have_selector 'h2', text: "Spending Limit: $50.00"}
        it { should_not have_link 'edit', href: edit_spending_limit_path(group) }
      end

      describe "with spending limit unset" do
        before { visit group_path(unset_spending_limit_group) }

        it { should_not have_selector 'label', text: "Set Spending Limit" }
        it { should_not have_selector 'input#spending_limit' }
        it { should_not have_selector "input[type='submit'][value='Set']"}
      end
        
      describe "with select date set" do
        it { should have_selector 'h2', text: 'Selection Date' }
        it { should have_selector 'span', text: group.select_date.date_in_words }
        it { should_not have_link 'edit', href: edit_select_date_path(group) }
      end

      describe "with select date unset" do
        before { visit group_path(unset_select_date_group) }

        it { should_not have_selector 'label', text: 'Set Select Day'}
        it { should_not have_selector '#select_date_select_date' }
      end

      describe "with open date set" do
        it { should have_selector 'h2', text: 'Open Date' }
        it { should have_selector 'span', text: group.open_date.date_in_words }
        it { should_not have_link 'edit', href: edit_open_date_path(group) }
      end

      describe "with open date unset" do
        before { visit group_path(unset_open_date_group) }

        it { should_not have_selector 'label', text: "Set Open Day" }
        it { should_not have_selector '#open_date_open_date'}
      end

      describe "shouldn't have remove links" do
        it { should_not have_link "remove", href: group_membership_path(group.id, group_user_1.id) }
        it { should_not have_link "remove", href: group_membership_path(group.id, group_user_2.id) }
        it { should_not have_link "remove", href: group_membership_path(group.id, group_user_3.id) }
      end
    end

    describe "when signed in" do
      before do 
        signin auth 
        visit group_path(group)
      end

      describe "as group owner" do
        it { should have_link 'Edit', href: edit_group_path(group)}
        it { should have_selector 'label', text: 'Invite a User' }
        it "should have selector #email" do
          within '.container' do
            expect(page).to have_selector "#email"
          end
        end

        describe "group edit link works" do
          before { click_link "Edit", href: edit_group_path(group) }

          it { should have_selector 'h1', text: "Edit #{group.name}" }
          it { should have_selector 'input#group_name' }
          it { should have_selector "input[type='submit'][value='Update Group']" }
        end
    
        describe "invite a user to a group" do
          it "should add an invite" do
            within '.container' do
               fill_in 'email', with: "test@example.com"

               expect { click_button "Invite" }.to change(Invite, :count).by(1)
             end
           end
        end

        describe "with spending limit set" do
          it { should_not have_selector 'label', text: "Set Spending Limit" }
          it { should have_selector 'h2', text: "Spending Limit: $50.00" }
          it { should have_link 'edit', href: edit_spending_limit_path(group) }

          describe "the edit link works" do
            before { click_link 'edit', href: edit_spending_limit_path(group) }

            it { should have_selector 'h1', text: "Set Spending Limit" }
            it { should have_selector '#spending_limit' }
            it { should have_selector "input[type='submit'][value='Set']"}
          end
        end

        describe "with spending limit unset" do
          before { visit group_path(unset_spending_limit_group) }
          it { should have_selector 'label', text: "Set Spending Limit" }
          it { should have_selector 'input#spending_limit' }
          it { should have_selector "input[type='submit'][value='Set']"}
        end

          
        describe "with select date set" do
          it { should have_selector 'h2', text: 'Selection Date' }
          it { should have_selector 'span', text: group.select_date.date_in_words }
          it { should have_link 'edit', href: edit_select_date_path(group) }

          describe "the edit link works" do
            before { click_link 'edit', href: edit_select_date_path(group) }

            it { should have_selector 'h1', text: "Reset Selection Day" }
            it { should have_selector 'input#select_date' }
            it { should have_selector "input[type='submit'][value='Set']"}
          end
        end

        describe "with select date unset" do
          before { visit group_path(unset_select_date_group) }

          it { should have_selector 'label', text: 'Set Selection Day'}
          it { should have_selector '#select_date' }

          describe "is able to set the select date" do
            before do
              fill_in "select_date", with: "01/12/2014"
              click_button "Set"
            end

            it { should have_selector 'h2', text: "Selection Date" }
            it { should have_selector 'span', text: "Dec 01, 2014" }
          end
        end

        describe "with open date set" do
          it { should have_selector 'h2', text: 'Open Date' }
          it { should have_selector 'span', text: group.open_date.date_in_words }
          it { should have_link 'edit', href: edit_open_date_path(group) }

          describe "the edit link works" do
            before { click_link 'edit', href: edit_open_date_path(group) }

            it { should have_selector 'h1', text: "Reset Open Day" }
            it { should have_selector 'input#open_date' }
            it { should have_selector "input[type='submit'][value='Set']"}
          end
        end

        describe "with open date unset" do
          before { visit group_path(unset_open_date_group) }

          it { should have_selector 'label', text: "Set Open Day" }
          it { should have_selector '#open_date'}

          describe "is able to set the open date" do
            before do
              fill_in "open_date", with: "01/12/2014"
              click_button "Set"
            end

            it { should have_selector 'h2', text: "Open Date" }
            it { should have_selector 'span', text: "Dec 01, 2014" }
          end
        end

        describe "with members" do
          it { should have_link group_user_1.view_name, href: user_path(group_user_1) }  
          it { should have_link group_user_2.view_name, href: user_path(group_user_2) }  
          it { should have_link group_user_3.view_name, href: user_path(group_user_3) }    

          describe "has remove links" do
            it { should have_link "remove", href: group_membership_path(group.id, group_user_1.id) }
            it { should have_link "remove", href: group_membership_path(group.id, group_user_2.id) }
            it { should have_link "remove", href: group_membership_path(group.id, group_user_3.id) }

            describe "clicking removes users from group" do
              before { click_link 'remove', href: group_membership_path(group.id, group_user_1.id) }

              it { should_not have_link group_user_1.view_name, href: user_path(group_user_1) }
            end
          end
        end  
      end

      describe "as group member but not owner" do
        before do
          signin auth_1
          visit group_path(group)
        end

        it { should have_selector 'h2', text: "Spending Limit: $50.00"}
        it { should_not have_link 'edit' }
        describe "with members" do
          it { should have_link group_user_1.view_name, href: user_path(group_user_1) }  
          it { should have_link group_user_2.view_name, href: user_path(group_user_2) }  
          it { should have_link group_user_3.view_name, href: user_path(group_user_3) }    

          describe "has no remove links" do
            it { should_not have_link "remove", href: group_membership_path(group.id, group_user_1.id) }
            it { should_not have_link "remove", href: group_membership_path(group.id, group_user_2.id) }
            it { should_not have_link "remove", href: group_membership_path(group.id, group_user_3.id) }
          end
        end 
      end    
    end
  end
end
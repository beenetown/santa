require 'spec_helper'

describe "group pages" do
  let(:user) { FactoryGirl.create(:user) }
  let(:auth) { FactoryGirl.create(:auth, user_id: user.id) }
  let(:group) { FactoryGirl.create(:group, owner_id: user.id) }
  
  let(:incorrect_user) { FactoryGirl.create(:user) }
  let(:incorrect_auth) { FactoryGirl.create(:auth, user_id: incorrect_user.id, 
                                                   name: "Incorrect User", 
                                                   email: "incorrect@example.com"
                                                   )} 
  
  subject { page }

  describe "edit page" do 
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
      it { should have_selector "label", text: "Name" }
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

  describe "index page" do
    before { visit groups_path }

    it { should have_selector 'h1', text: "All Groups" }
    it { should have_selector 'ul' }
  end

  describe "new page" do
    describe "when not signed in" do
      before { visit new_group_path }

      it { should have_selector '#alert', text: "Please sign in!" }
      it { should have_selector '.hero' }
      it { should_not have_selector 'h1', text: "New group"}
    end

    describe "when signed in" do
      before do
        signin auth 
        visit new_group_path
      end

      it { should_not have_selector '#alert' }
      it { should have_selector 'h1', text: "New group" }
      it { should have_selector 'label', text: "Name" }
      it { should have_selector '#group_name' }
      it { should have_selector '#group_owner_id' }
      it { should have_selector "input[type='submit'][value='Create Group']"}

      describe "with invalid info" do
        it "should not create a group" do
          expect { click_button "Create Group" }.not_to change(Group, :count)
          expect(page).to have_selector '#alert', text: "1 error prohibited this from being saved:"
        end
      end

      describe "with valid info" do
        before { fill_in 'group_name', with: "Newly Created Group" }
        
        it "should create a new group" do
          expect { click_button "Create Group" }.to change(Group, :count).by(1)
          expect(page).to have_selector 'h1', text: "Newly Created Group"
        end
      end
    end
  end

  describe "show page" do
    before { visit group_path(group) }
    
    it { should have_selector 'h1', text: group.name }
    
    describe "when not signed in" do
      it { should_not have_link 'Edit', href: edit_group_path(group)}
      it { should_not have_selector 'label', text: 'Invite Someone to This Group' }
      pending 'it { should_not have_selector '#email' } '

      describe "with select date set" do
        it { should have_selector 'h2', text: 'Selection Date' }
        it { should_not have_link 'edit', href: edit_selection_date_path(group) }
      end

      describe "with select date unset" do
        pending
        let!(:unset_select_date_group) { FactoryGirl.create(:group, owner_id: user.id, select_date: nil)}
        # subject { unset_select_date_group }

        before do
          visit group_path(unset_select_date_group)
        end

        it { should_not have_selector 'label', text: 'Set Selection Date'}
      end

      describe "with open date set" do
        pending
      end

      describe "with open date unset" do
  pending
      end
    end
  end
end
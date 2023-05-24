# frozen_string_literal: true

require 'spec_helper'

describe 'Taskboard/Filter/Assignee', js: true, sauce: true do
  fixtures %i[
    enabled_modules
    enumerations
    issue_categories
    issue_statuses
    issues
    member_roles
    members
    projects
    projects_trackers
    roles
    time_entries
    trackers
    users
    versions
    workflows
  ]

  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    project.enable_module! :dashboard
    login_as_admin

    visit '/projects/ecookbook'
    click_on 'Dashboard'
  end

  context 'menu' do
    let(:menu) { find_menu_container(:assignee) }

    it 'should have items for all members' do
      unset_all_filter
      find_menu_link(:assignee).click

      expect(menu).to have_link('Dave Lopper')
      expect(menu).to have_link('John Smith')
    end

    it 'should show all assignees in menu' do
      unset_all_filter
      find_menu_link(:assignee).click

      expect(menu).to have_selector(:xpath, './/*[contains(@class, "rdb-list")][2]//a', count: 2)
    end
  end

  it 'should allow to filter issues for assignee' do
    unset_all_filter
    select_filter :assignee, 'Dave Lopper'

    expect(page).to have_no_selector(:xpath, '//*[contains(@class, "rdb-property-assignee")][text()!="Dave Lopper"]')
    expect(page).to have_selector(:xpath, '//*[contains(@class, "rdb-property-assignee")][text()="Dave Lopper"]', count: 2)
  end

  it 'should allow to filter issues for groups' do
    unset_all_filter
    select_filter :assignee, 'Dave Lopper'

    expect(page).to have_no_selector(:xpath, '//*[contains(@class, "rdb-property-assignee")][text()!="Dave Lopper"]')
    expect(page).to have_selector(:xpath, '//*[contains(@class, "rdb-property-assignee")][text()="Dave Lopper"]', count: 2)
  end

  it 'should default to my issues' do
    expect(find_menu_link(:assignee)).to have_content('My Issues')
  end
end

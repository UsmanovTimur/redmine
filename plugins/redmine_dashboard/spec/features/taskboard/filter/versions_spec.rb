# frozen_string_literal: true

require 'spec_helper'

describe 'Taskboard/Filter/Versions', js: true, sauce: true do
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
    let(:menu) { find_menu_container(:versions) }

    it 'should have items for all versions' do
      unset_all_filter
      find_menu_link(:versions).click

      expect(menu).to have_link('2.0')
      expect(menu).to have_link('1.0')
    end
  end

  it 'should allow to filter issues for versions' do
    unset_all_filter
    select_filter :versions, '1.0'

    expect(page).to have_selector(:xpath, '//*[contains(@class, "rdb-property-version")][text()="1.0"]', count: 2)
    expect(page).to have_no_selector(:xpath, '//*[contains(@class, "rdb-property-version")][text()!="1.0"]')
  end

  it 'should default to most recent not closed verion' do
    expect(find_menu_link(:versions)).to have_content('1.0')
  end
end

require 'spec_helper'

feature 'view the flowdock settings' do

  stub_authorization!

  scenario 'admin sees a clickable link to the flowdock settings' do
    visit spree.edit_admin_general_settings_path
    expect(page).to have_link(I18n.t('flowdock.settings.link'))
    page.click_link_or_button(I18n.t('flowdock.settings.link'))
  end

  scenario 'admin sees the flowdock settings' do
    visit spree.edit_admin_flowdock_settings_path
    expect(find('h1')).to have_content(I18n.t('flowdock.settings.title'))
  end

  scenario 'admin sees a input field for the api token' do
    visit spree.edit_admin_flowdock_settings_path
    expect(page).to have_field('preferences[api_token_order_confirmation]')
  end

  scenario 'admin sees a link to update the flowdock settings' do
    visit spree.edit_admin_flowdock_settings_path
    expect(page).to have_button('Update')
  end

  scenario 'user can update the flowdock.io settings' do
    visit spree.edit_admin_flowdock_settings_path
    fill_in('preferences[api_token_order_confirmation]', with: 'z8o7ctz74rnt78')
    page.click_link_or_button('Update')
    expect(page.find_field('preferences[api_token_order_confirmation]').value).to eq 'z8o7ctz74rnt78'
  end
end

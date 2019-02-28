require 'rails_helper'

describe 'Responsible:login', type: :feature do
  let(:professor) { create(:professor) }

  before do
    visit new_responsible_session_path
  end

  context 'when login is valid', js: true do
    it 'show success message' do
      fill_in 'professor_username', with: professor.username
      fill_in 'professor_password', with: 'password'

      submit_form('input[name="commit"]')

      expect(page).to have_current_path responsible_root_path
      expect(page).to have_flash(:info, text: I18n.t('devise.sessions.signed_in'))
    end
  end

  context 'when login is not valid', js: true do
    it 'show errors messages' do
      fill_in 'professor_username', with: professor.username
      fill_in 'professor_password', with: 'passworda'

      submit_form('input[name="commit"]')

      expect(page).to have_current_path new_responsible_session_path

      resource_name = Professor.human_attribute_name(:username)

      warning_message = I18n.t('devise.failure.invalid', authentication_keys: resource_name)
      expect(page).to have_flash(:warning, text: warning_message)
    end
  end

  context 'when responsible is not authenticated' do
    before do
      visit responsible_academics_path
    end

    it 'redirect to the login page', js: true do
      expect(page).to have_current_path new_responsible_session_path
      expect(page).to have_flash(:warning, text: I18n.t('devise.failure.unauthenticated'))
    end
  end
end

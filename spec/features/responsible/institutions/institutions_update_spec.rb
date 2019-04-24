require 'rails_helper'

describe 'Institution::update', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Institution.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:institution) { create(:institution) }

    before do
      visit edit_responsible_institution_path(institution)
    end

    context 'when data is valid', js: true do
      it 'updates the institution' do
        new_name = 'Teste'
        fill_in 'institution_name', with: new_name

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_institution_path(institution)

        success_message = I18n.t('flash.actions.update.f', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_content(new_name)
      end
    end

    context 'when the institution is not valid', js: true do
      it 'show errors' do
        fill_in 'institution_name', with: ''
        fill_in 'institution_trade_name', with: ''
        fill_in 'institution_cnpj', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.institution_name')
        expect(page).to have_message(message_blank_error, in: 'div.institution_trade_name')
        expect(page).to have_message(message_blank_error, in: 'div.institution_cnpj')
      end
    end
  end
end

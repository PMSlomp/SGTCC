require 'rails_helper'

describe 'Signature::sign', type: :feature, js: true do
  let(:orientation) { create(:orientation) }
  let(:academic_signature) { orientation.signatures.where(user_type: :academic).last }
  let(:academic) { academic_signature.user }

  before do
    login_as(academic, scope: :academic)
    visit academics_signature_path(academic_signature)
  end

  describe '#sign' do
    context 'when signs the signature of the term of accept institution' do
      it 'signs the document of the term of accept institution' do
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: academic.ra
        fill_in 'password_confirmation', with: 'password'
        find('button[id="login_confirmation_button"]', text: sign_button).click

        expect(page).to have_message(signature_signed_success_message, in: 'div.swal-text')

        academic_signature.reload

        date = I18n.l(academic_signature.updated_at, format: :short)
        time = I18n.l(academic_signature.updated_at, format: :time)
        role = signature_role(academic.gender, academic_signature.user_type)
        expect(page).to have_content(signature_register(academic.name, role, date, time))
      end
    end

    context 'when the password is wrong' do
      it 'shows alert message' do
        find('button[id="signature_button"]', text: signature_button).click
        fill_in 'login_confirmation', with: academic.ra
        fill_in 'password_confirmation', with: '123'
        find('button[id="login_confirmation_button"]', text: sign_button).click

        expect(page).to have_message(signature_login_alert_message, in: 'div.swal-text')
      end
    end
  end
end
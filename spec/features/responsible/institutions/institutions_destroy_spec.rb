require 'rails_helper'

describe 'Institution::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:institution) { create(:institution) }
  let(:resource_name) { Institution.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institutions_path
  end

  describe '#destroy' do
    context 'when institution is destroyed', js: true do
      it 'show success message' do
        within first('.destroy').click
        accept_alert
        expect(page).to have_flash(:success, text: flash_message('destroy.f', resource_name))
        expect(page).not_to have_content(institution.name)
      end
    end
  end
end

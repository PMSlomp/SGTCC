require 'rails_helper'

describe 'Professors::show', type: :feature do
  let!(:professor) { create(:professor) }

  before do
    visit site_professor_path(professor)
  end

  describe '#show' do
    context 'when shows the professor' do
      it 'shows the professor' do
        gender = I18n.t("enums.genders.#{professor.gender}")
        is_active = I18n.t("helpers.boolean.#{professor.is_active}")
        available_advisor = I18n.t("helpers.boolean.#{professor.available_advisor}")

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       professor.lattes,
                                       gender,
                                       is_active,
                                       available_advisor,
                                       professor.scholarity.name,
                                       professor.professor_type.name])
      end

      it 'shows the professor in progress orientations' do
        professor.orientations_by_status('IN_PROGRESS').each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end

      it 'shows the professor approved orientations' do
        professor.orientations_by_status('APPROVED').each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name])
        end
      end
    end
  end
end

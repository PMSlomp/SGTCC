require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    responsible = create(:responsible)
    login_as(responsible, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of tcc one calendar' do
      it 'shows all the orientations of tcc one with options' do
        orientations = create_list(:orientation_tcc_one, 2)

        index_url = responsible_orientations_tcc_one_path
        visit index_url

        orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name,
                                         orientation.academic.ra,
                                         orientation.calendar.year_with_semester_and_tcc])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end

    context 'when shows all the orientations of tcc two calendar' do
      it 'shows all the orientations of tcc two with options' do
        orientations = create_list(:orientation_tcc_two, 2)

        index_url = responsible_orientations_tcc_two_path
        visit index_url

        orientations.each do |orientation|
          expect(page).to have_contents([orientation.short_title,
                                         orientation.advisor.name,
                                         orientation.academic.name,
                                         orientation.academic.ra,
                                         orientation.calendar.year_with_semester_and_tcc])
        end
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
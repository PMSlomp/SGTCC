require 'rails_helper'

describe 'Professor::create', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Professor.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_professor_path
    end

    context 'when professor is valid' do
      it 'create an professor' do
        attributes = attributes_for(:professor)
        fill_in 'professor_name', with: attributes[:name]
        fill_in 'professor_email', with: attributes[:email]
        fill_in 'professor_username', with: attributes[:username]
        fill_in 'professor_lattes', with: attributes[:lattes]
        find('span', text: Professor.human_genders.first[0]).click
        find('.fa-bold').click

        selectize(Scholarity.first.name, from: 'professor_scholarity_id')
        selectize(ProfessorType.first.name, from: 'professor_professor_type_id')

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_professors_path
        expect(page).to have_flash(:success, text: flash_message('create.m', resource_name))
        expect_page_has_content(attributes[:name], in: 'table tbody')
      end
    end

    context 'when professor is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect_page_has_content(message_blank_error, in: 'div.professor_name')
        expect_page_has_content(message_blank_error, in: 'div.professor_email')
        expect_page_has_content(message_blank_error, in: 'div.professor_username')
        expect_page_has_content(message_blank_error, in: 'div.professor_gender')
        expect_page_has_content(message_blank_error, in: 'div.professor_lattes')
        expect_page_has_content(message_blank_error, in: 'div.professor_working_area')
      end
    end
  end
end

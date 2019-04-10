require 'rails_helper'

describe 'Professor::search', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:professors) { create_list(:professor, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#search' do
    context 'when finds the professor' do
      it 'finds the professor by the name', js: true do
        professor = professors.first

        fill_in 'term', with: professor.name
        first('#search').click

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       professor.created_at.strftime('%d/%m/%Y')])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message', js: true do
        fill_in 'term', with: 'a1#23123rere'
        first('#search').click

        expect(page).to have_message(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end
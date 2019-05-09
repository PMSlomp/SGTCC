require 'rails_helper'

describe 'ExternalMember::search', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:external_members) { create_list(:external_member, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_external_members_path
  end

  describe '#search' do
    context 'when finds the external member' do
      it 'finds the external member by the name' do
        external_member = external_members.first

        fill_in 'term', with: external_member.name
        first('#search').click

        expect(page).to have_contents([external_member.name,
                                       external_member.email,
                                       short_date(external_member.created_at)])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#23123rere'
        first('#search').click
        expect_page_has_content(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end

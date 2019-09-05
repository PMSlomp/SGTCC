require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:examination_boards) { create_list(:examination_board_tcc_one, 2) }

  before do
    examination_boards.each do |examination_board|
      examination_board.professors << professor
    end
    login_as(professor, scope: :professor)
    visit professors_root_path
  end

  describe '#index' do
    context 'when shows the examination boards' do
      it 'shows the examination boards' do
        examination_boards.each do |examination_board|
          expect(page).to have_contents([examination_board.orientation.academic_with_calendar,
                                         examination_board.orientation.advisor.name_with_scholarity,
                                         examination_board.place,
                                         datetime(examination_board.date)])

          examination_board.professors.each do |professor|
            expect(page).to have_content(professor.name_with_scholarity)
          end

          examination_board.external_members.each do |external_member|
            expect(page).to have_content(external_member.name_with_scholarity)
          end
        end
      end
    end
  end
end
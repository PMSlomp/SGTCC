require 'rails_helper'

RSpec.describe Orientation, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:calendar) }
    it { is_expected.to belong_to(:academic) }
    it { is_expected.to belong_to(:advisor).class_name('Professor') }
    it { is_expected.to belong_to(:institution) }
    it { is_expected.to have_many(:orientation_supervisors).dependent(:delete_all) }

    it 'is expected to have many professor supervisors' do
      is_expected.to have_many(:professor_supervisors).through(:orientation_supervisors)
                                                      .dependent(:destroy)
    end

    it 'is expected to have many external member supervisors' do
      is_expected.to have_many(:external_member_supervisors).through(:orientation_supervisors)
                                                            .dependent(:destroy)
    end
  end

  describe '#short_title' do
    it 'returns the short title' do
      title = 'title' * 40
      orientation = create(:orientation, title: title)
      expect(orientation.short_title).to eq("#{title[0..35]}...")
    end

    it 'returns the title' do
      title = 'title'
      orientation = create(:orientation, title: title)
      expect(orientation.short_title).to eq(title)
    end
  end

  describe '#by_tcc' do
    before do
      create_list(:orientation, 5)
    end

    it 'returns the orientations by tcc one' do
      order_by = 'calendars.year DESC, calendars.semester ASC, title'
      orientations_tcc_one = Orientation.joins(:calendar)
                                        .where(calendars: { tcc: Calendar.tccs[:one] })
                                        .page(1)
                                        .search('')
                                        .includes(:advisor, :academic, :calendar)
                                        .order(order_by)
      expect(Orientation.by_tcc_one(1, '')).to eq(orientations_tcc_one)
    end

    it 'returns the orientations by tcc two' do
      order_by = 'calendars.year DESC, calendars.semester ASC, title'
      orientations_tcc_two = Orientation.joins(:calendar)
                                        .where(calendars: { tcc: Calendar.tccs[:two] })
                                        .page(1)
                                        .search('')
                                        .includes(:advisor, :academic, :calendar)
                                        .order(order_by)
      expect(Orientation.by_tcc_two(1, '')).to eq(orientations_tcc_two)
    end
  end

  describe '#by_current_tcc' do
    before do
      create(:current_orientation_tcc_one)
      create(:current_orientation_tcc_two)
    end

    it 'returns the current orientations by tcc one' do
      query = { tcc: Calendar.tccs[:one],
                year: Calendar.current_year,
                semester: Calendar.current_semester }
      orientations_tcc_one = Orientation.joins(:calendar)
                                        .where(calendars: query)
                                        .page(1)
                                        .search('')
                                        .includes(:advisor, :academic, :calendar)
                                        .order('academics.name')
      expect(Orientation.by_current_tcc_one(1, '')).to eq(orientations_tcc_one)
    end

    it 'returns the current orientations by tcc two' do
      query = { tcc: Calendar.tccs[:two],
                year: Calendar.current_year,
                semester: Calendar.current_semester }
      orientations_tcc_two = Orientation.joins(:calendar)
                                        .where(calendars: query)
                                        .page(1)
                                        .search('')
                                        .includes(:advisor, :academic, :calendar)
                                        .order('academics.name')
      expect(Orientation.by_current_tcc_two(1, '')).to eq(orientations_tcc_two)
    end
  end

  describe '#search' do
    let(:orientation) { create(:orientation) }

    context 'when finds orientation by attributes' do
      it 'returns orientation by title' do
        results_search = Orientation.search(orientation.title)
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        results_search = Orientation.search(orientation.academic.name)
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by academic ra' do
        results_search = Orientation.search(orientation.academic.ra)
        expect(orientation.academic.ra).to eq(results_search.first.academic.ra)
      end

      it 'returns orientation by advisor name' do
        results_search = Orientation.search(orientation.advisor.name)
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation with accents' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema de Gestão')
        results_search = Orientation.search('Sistema de Gestao')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'João')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search(academic.name)
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Júlio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search(advisor.name)
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation on search term with accents' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema de Gestao')
        results_search = Orientation.search('Sistema de Gestão')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'Joao')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search('João')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Julio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search('Júlio')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end

    context 'when finds orientation ignoring the case sensitive' do
      it 'returns orientation by title' do
        orientation = create(:orientation, title: 'Sistema')
        results_search = Orientation.search('sistema')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by title on search term' do
        orientation = create(:orientation, title: 'sistema')
        results_search = Orientation.search('SISTEMA')
        expect(orientation.title).to eq(results_search.first.title)
      end

      it 'returns orientation by academic name' do
        academic = create(:academic, name: 'Joao')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search('joao')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by academic name on search term' do
        academic = create(:academic, name: 'joao')
        orientation = create(:orientation, academic: academic)
        results_search = Orientation.search('JOAO')
        expect(orientation.academic.name).to eq(results_search.first.academic.name)
      end

      it 'returns orientation by advisor name' do
        advisor = create(:professor, name: 'Julio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search('julio')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end

      it 'returns orientation by advisor name on search term' do
        advisor = create(:professor, name: 'julio')
        orientation = create(:orientation, advisor: advisor)
        results_search = Orientation.search('JULIO')
        expect(orientation.advisor.name).to eq(results_search.first.advisor.name)
      end
    end
  end

  describe '#renew' do
    context 'when the orientation is renewed' do
      let!(:calendar) { create(:calendar_tcc_two, year: 2019, semester: 1) }
      let!(:next_calendar) { create(:calendar_tcc_two, year: 2019, semester: 2) }
      let!(:orientation) { create(:orientation_renewed, calendar: calendar) }
      let(:new_orientation) { orientation.dup }
      let(:renewed_orientation) do
        orientation.renew(orientation.renewal_justification)
      end

      it 'is equal calendar' do
        new_orientation.calendar = next_calendar
        expect(renewed_orientation.calendar).to eq(new_orientation.calendar)
      end

      it 'is equal title' do
        expect(renewed_orientation.title).to eq(new_orientation.title)
      end

      it 'is equal justification' do
        expect(renewed_orientation.renewal_justification).to eq(
          new_orientation.renewal_justification
        )
      end

      it 'is equal academic' do
        expect(renewed_orientation.academic).to eq(new_orientation.academic)
      end

      it 'is equal advisor' do
        expect(renewed_orientation.advisor).to eq(new_orientation.advisor)
      end
    end
  end

  describe '#cancel' do
    context 'when the orientation is cancelled' do
      let(:orientation) { create(:orientation) }

      it 'is status equal cancelled' do
        orientation.cancel('Justification')
        orientation.reload
        expect(orientation.status).to eq('cancelada')
      end
    end
  end
end
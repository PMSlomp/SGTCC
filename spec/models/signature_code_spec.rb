require 'rails_helper'

RSpec.describe SignatureCode, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end
end

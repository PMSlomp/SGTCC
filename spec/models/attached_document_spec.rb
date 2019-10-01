require 'rails_helper'

RSpec.describe AttachedDocument, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:file) }
  end
end

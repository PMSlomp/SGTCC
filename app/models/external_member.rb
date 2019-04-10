class ExternalMember < ApplicationRecord
  include Classifiable
  include Searchable
  include ProfileImage

  devise :database_authenticatable,
         :rememberable, :validatable,
         :recoverable, authentication_keys: [:email]

  searchable :email, name: { unaccent: true }

  belongs_to :scholarity

  validates :name,
            presence: true

  validates :gender,
            presence: true

  validates :working_area,
            presence: true

  validates :personal_page,
            allow_blank: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp }

  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: false }
end
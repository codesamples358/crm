class Player < ApplicationRecord
  PHONE_REGEXP = /\+7 \(\d{3}\) \d{3}-\d{4}/

  validates :phone, uniqueness: true, format: PHONE_REGEXP, presence: true
  validate :additional_phone

  validates :email, uniqueness: true, format: Devise.email_regexp
  validates :name, presence: true

  attr_accessor :phone_no_mask

  ATTR_VALUES = {
    info_source: [ 'Друзья', 'Интернет', 'Соц. сети', 'Другое' ]
  }

  def additional_phone
    if self.phone2.present?
      unless phone2 =~ PHONE_REGEXP
        errors.add(:phone2, :invalid)
      end
    end
  end
end

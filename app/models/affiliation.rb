class Affiliation < ApplicationRecord
  belongs_to :villain
  belongs_to :organization
end

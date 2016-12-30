class Condition < ApplicationRecord
  has_and_belongs_to_many :villains
end

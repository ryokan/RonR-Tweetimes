class Poster < ActiveRecord::Base
  has_many :logs
  has_many :entries
end

class Message < ApplicationRecord
  belongs_to :chef
  validates :content, presence: true
  validates :chef_id, presence: true
end
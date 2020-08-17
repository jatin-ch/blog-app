class Article < ApplicationRecord
	has_many :comments, dependent: :destroy
	belongs_to :user
	belongs_to :category
	has_and_belongs_to_many :tags
	has_many :likes, as: :likeable

	validates :title, presence: true, length: { minimum: 5 }

	accepts_nested_attributes_for :tags
end

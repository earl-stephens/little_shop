class Review < ApplicationRecord

  belongs_to :item
  belongs_to :user

  validates_numericality_of :rating, less_than_or_equal_to: 5
  validates_numericality_of :rating, greater_than_or_equal_to: 1

  def author
    User.find(self.user_id).name
  end
end

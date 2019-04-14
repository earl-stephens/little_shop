require "rails_helper"

RSpec.describe Review, type: :model do
  describe 'relationships' do
    it { should belong_to(:user)}
    it { should belong_to(:item)}
  end

  describe 'validations' do
    it { should validate_numericality_of(:rating)
          .is_greater_than_or_equal_to(1)}
    it { should validate_numericality_of(:rating)
          .is_less_than_or_equal_to(5)}
  end

  describe 'instance methods' do
    it '#author' do
      @user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
      @merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
      @item1 = @merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
      @review1 = @item1.reviews.create!(title: "review1", description: "bad", rating: 1, user_id: @user.id)

      expect(@review1.author).to eq(@user.name)
    end
  end
end

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_presence_of :description }
    it { should validate_presence_of :inventory }
    it { should validate_numericality_of(:inventory).only_integer }
    it { should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0) }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many(:reviews)}
  end

  describe 'class methods' do
    describe 'item popularity' do
      before :each do
        merchant = create(:merchant)
        @items = create_list(:item, 6, user: merchant)
        user = create(:user)

        order = create(:shipped_order, user: user)
        create(:fulfilled_order_item, order: order, item: @items[3], quantity: 7)
        create(:fulfilled_order_item, order: order, item: @items[1], quantity: 6)
        create(:fulfilled_order_item, order: order, item: @items[0], quantity: 5)
        create(:fulfilled_order_item, order: order, item: @items[2], quantity: 3)
        create(:fulfilled_order_item, order: order, item: @items[5], quantity: 2)
        create(:fulfilled_order_item, order: order, item: @items[4], quantity: 1)
      end

      it '.item_popularity' do
        expect(Item.item_popularity(4, :desc)).to eq([@items[3], @items[1], @items[0], @items[2]])
        expect(Item.item_popularity(4, :asc)).to eq([@items[4], @items[5], @items[2], @items[0]])
      end

      it '.popular_items' do
        actual = Item.popular_items(3)
        expect(actual).to eq([@items[3], @items[1], @items[0]])
        expect(actual[0].total_ordered).to eq(7)
      end

      it '.unpopular_items' do
        actual = Item.unpopular_items(3)
        expect(actual).to eq([@items[4], @items[5], @items[2]])
        expect(actual[0].total_ordered).to eq(1)
      end
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @order_item_1 = create(:fulfilled_order_item, item: @item, created_at: 4.days.ago, updated_at: 12.hours.ago)
      @order_item_2 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
      @order_item_3 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
      @order_item_4 = create(:order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)
    end

    # it '.set_item_slug' do
    #   merch = User.create!(email: "joe@gmail.com", password: "password", role: 1, name: "Joe", address: "123 Main", city: "Tucson", state: "AZ", zip: "77823")
    #   item1 = Item.create!(name: "widget", price: 2.3, description: "green widget", image: "https://picsum.photos/200/300?image=1", inventory: 23, merchant_id: merch.id)
    #
    #   expect(item1.slug).to eq(item1.set_item_slug)
    # end

    describe "#average_fulfillment_time" do
      it "calculates the average number of seconds between order_item creation and completion" do
        expect(@item.average_fulfillment_time).to eq(158400)
      end

      it "returns nil when there are no order_items" do
        unfulfilled_item = create(:item, user: @merchant)
        unfulfilled_order_item = create(:order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago)

        expect(unfulfilled_item.average_fulfillment_time).to be_falsy
      end
    end

    describe "#ordered?" do
      it "returns true if an item has been ordered" do
        expect(@item.ordered?).to be_truthy
      end

      it "returns false when the item has never been ordered" do
        unordered_item = create(:item)
        expect(unordered_item.ordered?).to be_falsy
      end
    end

    describe '#avg_rating' do
      it 'gives average rating for an item' do
        @user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
        @merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
        @item1 = @merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
        @item2 = @merchant.items.create!(name: "item2", active: true, price: 3.5, description: "second item", inventory: 65, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
        @item3 = @merchant.items.create!(name: "item3", active: true, price: 4.5, description: "third item", inventory: 75, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
        @review1 = @item1.reviews.create!(title: "review1", description: "bad", rating: 2, user_id: @user.id)
        @review2 = @item1.reviews.create!(title: "review2", description: "bleh", rating: 3, user_id: @user.id)
        @review3 = @item1.reviews.create!(title: "review3", description: "ok", rating: 3, user_id: @user.id)
        @review4 = @item1.reviews.create!(title: "review4", description: "better", rating: 4, user_id: @user.id)
        @review5 = @item1.reviews.create!(title: "review5", description: "best", rating: 5, user_id: @user.id)

        expect(@item1.avg_rating).to eq(3.4)
      end
    end

  end
end

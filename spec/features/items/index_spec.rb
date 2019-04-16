require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'items index workflow', type: :feature do
  describe 'shows all active items to visitors' do
    it 'displays basic item data' do
      items = create_list(:item, 3)
      out_of_stock = create(:item, inventory: 0)
      inactive_items = create_list(:inactive_item, 2)

      visit items_path

      items.each do |item|
        within "#item-#{item.id}" do
          expect(page).to have_link(item.name)
          expect(page).to have_content("Sold by: #{item.user.name}")
          expect(page).to have_content("In stock: #{item.inventory}")
          expect(page).to have_content(number_to_currency(item.price))
          expect(page.find("#item-#{item.id}-image")['src']).to have_content(item.image)
        end
      end
      within "#item-#{out_of_stock.id}" do
        expect(page).to have_content("Out of Stock")
      end
      inactive_items.each do |item|
        expect(page).to_not have_css("#item-#{item.id}")
        expect(page).to_not have_content(item.name)
      end
    end

    it 'doesnt change slug when other attributes change' do
      merch = create(:merchant)
      item = Item.create!(name: "widget", price: 2.0, description: "my widget", image: "https://picsum.photos/200/300?image=1", inventory: 35, merchant_id: merch.id)
      initial_slug = item.slug
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merch)

      visit edit_dashboard_item_path(item)

      fill_in :item_description, with: "bigger widget"
      fill_in :item_price, with: 3.5
      fill_in :item_inventory, with: 48
      fill_in :item_image, with: "https://picsum.photos/200/300?image=1000"
      click_button "Update Item"

      item.reload
      final_slug = item.slug
      expect(final_slug).to eq(initial_slug)
    end

    it 'changes slug when name changes' do
      merch = create(:merchant)
      item = Item.create!(name: "widget", price: 2.0, description: "my widget", image: "https://picsum.photos/200/300?image=1", inventory: 35, merchant_id: merch.id)
      initial_slug = item.slug
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merch)

      visit edit_dashboard_item_path(item)

      fill_in :item_name, with: "Widget 2.0"
      click_button "Update Item"

      item.reload
      final_slug = item.slug
      expect(final_slug).to_not eq(initial_slug)
    end

    it 'doesnt change slug on enable' do
      merch = create(:merchant)
      item1 = Item.create!(name: "widget", price: 2.0, description: "my widget", image: "https://picsum.photos/200/300?image=1", inventory: 35, merchant_id: merch.id)
      initial_slug = item1.slug
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merch)
      visit dashboard_items_path

      within "#item-#{item1.id}" do
        click_button 'Enable Item'
      end

      item1.reload
      final_slug = item1.slug
      expect(final_slug).to eq(initial_slug)
    end

    it 'doesnt change slug on disable' do
      merch = create(:merchant)
      item1 = Item.create!(active: true, name: "widget", price: 2.0, description: "my widget", image: "https://picsum.photos/200/300?image=1", inventory: 35, merchant_id: merch.id)
      initial_slug = item1.slug
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merch)
      visit dashboard_items_path

      expect(item1.active).to eq(true)

      within "#item-#{item1.id}" do
        click_button 'Disable Item'
      end
      item1.reload
      expect(item1.active).to eq(false)

      final_slug = item1.slug
      expect(final_slug).to eq(initial_slug)
    end

    it 'doesnt change the slug on inventory adjustments' do
      user1 = create(:user)
      merch = create(:merchant)
      item1 = Item.create!(active: true, name: "widget", price: 2.0, description: "my widget", image: "https://picsum.photos/200/300?image=1", inventory: 35, merchant_id: merch.id)
      order1 = Order.create!(user_id: user1.id, status: 2)
      oi1 = OrderItem.create!(order_id: order1.id, item_id: item1.id, quantity: 10, price: 2.0)
      initial_slug = item1.slug
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merch)

      oi1.fulfill

      item1.reload
      final_slug = item1.slug
      expect(item1.inventory).to eq(25)

      expect(final_slug).to eq(initial_slug)
    end
  end
end

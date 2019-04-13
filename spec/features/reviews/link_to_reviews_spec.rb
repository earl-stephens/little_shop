require "rails_helper"

describe 'user sees a link for leaving a review' do
  it 'on the order show page' do
    user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
    merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
    item1 = merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    item2 = merchant.items.create!(name: "item2", active: true, price: 3.5, description: "second item", inventory: 65, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    item3 = merchant.items.create!(name: "item3", active: true, price: 4.5, description: "third item", inventory: 75, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    order = user.orders.create!(status: 2)
    oi1 = order.order_items.create!(item_id: item1.id, quantity: 4, price: 2.5, fulfilled: true)
    oi2 = order.order_items.create!(item_id: item2.id, quantity: 5, price: 3.5, fulfilled: true)
    oi3 = order.order_items.create!(item_id: item3.id, quantity: 6, price: 4.5, fulfilled: true)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_order_path(order)

    within "#oitem-#{oi1.id}"do
      expect(page).to have_link("Leave a review")
    end
    within "#oitem-#{oi2.id}"do
      expect(page).to have_link("Leave a review")
    end
    within "#oitem-#{oi3.id}"do
      expect(page).to have_link("Leave a review")
    end
  end

  it 'wont have a review link on an uncompleted order page' do
    user = User.create!(name: "Joe", email: "joe@gmail.com", password: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345")
    merchant = User.create!(name: "Jim", email: "jim@gmail.com", password: "password", address: "321 Main", city: "Charleston", state: "SC", zip: "12345", role: 1)
    item1 = merchant.items.create!(name: "item1", active: true, price: 2.5, description: "first item", inventory: 55, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    item2 = merchant.items.create!(name: "item2", active: true, price: 3.5, description: "second item", inventory: 65, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    item3 = merchant.items.create!(name: "item3", active: true, price: 4.5, description: "third item", inventory: 75, image: "https://frugalyork.files.wordpress.com/2011/03/jelly-beans-green-apple.gif?w=225&h=300&zoom=2")
    order = user.orders.create!(status: 2)
    order1 = user.orders.create!(status: 0)
    order2 = user.orders.create!(status: 1)
    oi1 = order.order_items.create!(item_id: item1.id, quantity: 4, price: 2.5, fulfilled: true)
    oi2 = order.order_items.create!(item_id: item2.id, quantity: 5, price: 3.5, fulfilled: true)
    oi3 = order.order_items.create!(item_id: item3.id, quantity: 6, price: 4.5, fulfilled: true)
    oi4 = order1.order_items.create!(item_id: item1.id, quantity: 4, price: 2.5, fulfilled: true)
    oi5 = order1.order_items.create!(item_id: item2.id, quantity: 5, price: 3.5, fulfilled: false)
    oi6 = order2.order_items.create!(item_id: item1.id, quantity: 4, price: 4.5, fulfilled: true)
    oi7 = order2.order_items.create!(item_id: item2.id, quantity: 5, price: 5.5, fulfilled: false)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit profile_order_path(order)

    within "#oitem-#{oi1.id}"do
      expect(page).to have_link("Leave a review")
    end

    visit profile_order_path(order1)

    within "#oitem-#{oi4.id}"do
      expect(page).to_not have_link("Leave a review")
    end
    within "#oitem-#{oi5.id}"do
      expect(page).to_not have_link("Leave a review")
    end

    visit profile_order_path(order2)
    
    within "#oitem-#{oi6.id}"do
      expect(page).to_not have_link("Leave a review")
    end
    within "#oitem-#{oi7.id}"do
      expect(page).to_not have_link("Leave a review")
    end

  end
end

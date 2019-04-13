require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant)

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

inactive_merchant_1 = create(:inactive_merchant)
inactive_user_1 = create(:inactive_user)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
create_list(:item, 10, user: merchant_1)

inactive_item_1 = create(:inactive_item, user: merchant_1)
inactive_item_2 = create(:inactive_item, user: inactive_merchant_1)

Random.new_seed
rng = Random.new

order = create(:shipped_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(3)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(5)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)

# pending order
order = create(:order, user: user)
create(:order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).days.ago, updated_at: rng.rand(23).hours.ago)

order = create(:cancelled_order, user: user)
create(:order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
create(:order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)

order = create(:packaged_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(4)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)





puts 'seed data finished'
puts "Users created: #{User.count.to_i}"
puts "Orders created: #{Order.count.to_i}"
puts "Items created: #{Item.count.to_i}"
puts "OrderItems created: #{OrderItem.count.to_i}"

# OrderItem.destroy_all
# Order.destroy_all
# Item.destroy_all
# User.destroy_all
#
# #six users(shoppers)
# @user_11 = User.create!(role: 1, enabled: false, name: "Sally Shopper", street: "123 Busy Way", city: "Denver", state: "CO", zip: "80222", email: "sally@gmail.com", password: "12345678")
# @user_12 = User.create(role: 1, enabled: false, name: "Sam Spender", street: "1 Old Street", city: "Golden", state: "CO", zip: "80403", email: "sam@gmail.com", password: "password")
# @user_13 = User.create(role: 1, enabled: false, name: "Bill Jones", street: "2 Cole Ave", city: "Lakewood", state: "CO", zip: "80228", email: "bill@gmail.com", password: "yolo1234")
# @user_14 = User.create(role: 1, enabled: false, name: "Bobby Buyer", street: "1 Way Too Busy", city: "Los Angeles", state: "CA", zip: "90210", email: "bobby@gmail.com", password: "yolo1234")
# @user_15 = User.create(role: 1, enabled: false, name: "Betty Buyer", street: "1 Way Too Busy", city: "Los Angeles", state: "CA", zip: "90210", email: "betty@gmail.com", password: "yolo1234")
# @user_16 = User.create(role: 1, enabled: false, name: "Paul Purchaser", street: "60 Stories Too Many", city: "Seattle", state: "WA", zip: "98315", email: "paul@gmail.com", password: "password")
# # @user_000 = User.create(role: 1, enabled: false, name: "Paul schlattmann", street: "60 Stories Too Many", city: "Seattle", state: "OR", zip: "98315", email: "paul.h.schlattmann@gmail.com", password: "password")
#
# #five merchants
# @user_21 = User.create(role: 2, enabled: true, name: "Mike Merchant", street: "1 Old Street", city: "Golden", state: "CO", zip: "80403", email: "mike@gmail.com", password: "password")
# @user_22 = User.create(role: 2, enabled: true, name: "Pam Pusher", street: "2 Cole Ave", city: "Lakewood", state: "CO", zip: "80228", email: "pam@gmail.com", password: "yolo1234")
# @user_23 = User.create(role: 2, enabled: true, name: "Dealing Doug", street: "1 Way Too Busy", city: "Los Angeles", state: "CA", zip: "90210", email: "doug@gmail.com", password: "yolo1234")
# @user_24 = User.create(role: 2, enabled: true, name: "Carl Carsalesman", street: "1 Way Too Busy", city: "Los Angeles", state: "CA", zip: "90210", email: "carl@gmail.com", password: "yolo1234")
# @user_25 = User.create(role: 2, enabled: true, name: "Steve Seller", street: "60 Stories Too Many", city: "Seattle", state: "WA", zip: "98315", email: "steve@gmail.com", password: "password")
#
# #two admins
# @user_31 = User.create(role: 3, enabled: true, name: "Aaron Admin", street: "1 Old Street", city: "Golden", state: "CO", zip: "80403", email: "aaron@gmail.com", password: "password")
# @user_32 = User.create(role: 3, enabled: true, name: "Otis Overseer", street: "2 Cole Ave", city: "Lakewood", state: "CO", zip: "80228", email: "otis@gmail.com", password: "secure123")
#
# #beers
# @beer_1 = @user_21.items.create(name: "Heineken", description: "Pale lager, 5%", item_price: 4.00, stock: 56, enabled: true, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Heineken.jpg/156px-Heineken.jpg")
# @beer_2 = @user_22.items.create(name: "Guiness", description: "Dry stout, 4.2%", item_price: 6.50, stock: 68, enabled: true, image: "https://upload.wikimedia.org/wikipedia/en/thumb/f/fe/Guinness-original-logo.svg/440px-Guinness-original-logo.svg.png")
# @beer_3 = @user_23.items.create(name: "Samuel Adams", description: "Lager, 4.9%", item_price: 4.25, stock: 38, enabled: true, image: "https://media3.webcollage.net/ba5aa7c6e5fdf1a927cf12d2cc841b1face3d275?response-content-type=image%2Fpng&AWSAccessKeyId=AKIAIIE5CHZ4PRWSLYKQ&Expires=1893538567&Signature=gw9LNzoG4tgto7t%2FmRRJKpKB0PY%3D")
# @beer_4 = @user_24.items.create(name: "Corona", description: "Pale lager, 4.6%", item_price: 3.00, stock: 77, enabled: true, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Corona-6Pack.JPG/440px-Corona-6Pack.JPG")
# @beer_5 = @user_25.items.create(name: "Budweiser", description: "Pale lager, 5%", item_price: 3.75, stock: 123, enabled: true, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Bud_and_Budvar.jpg/440px-Bud_and_Budvar.jpg")
# @beer_6 = @user_21.items.create(name: "Coors Light", description: "Pale lager, 5%", item_price: 3.00, stock: 99, enabled: true, image: "https://grandcanyonspirits.com/wp-content/uploads/2018/10/coors.jpg")
# @beer_7 = @user_22.items.create(name: "Miller High Life", description: "Lager, 4.6%", item_price: 3.25, stock: 143, enabled: true, image: "https://products0.imgix.drizly.com/ci-miller-high-life-1c0b560ccca972a0.jpeg?auto=format%2Ccompress&fm=jpeg&q=20")
# @beer_8 = @user_23.items.create(name: "Blue Moon", description: "Witbier, 5.4%", item_price: 5.50, stock: 88, enabled: true, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Blue_moon%28beer%29.jpg/440px-Blue_moon%28beer%29.jpg")
# @beer_9 = @user_24.items.create(name: "Corona Light", description: "Pale lager, 4.6%", item_price: 4.00, stock: 135, enabled: true, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Corona-6Pack.JPG/440px-Corona-6Pack.JPG")
# @beer_10 = @user_25.items.create(name: "Bud Light", description: "Lite lager, 4.2%", item_price: 3.75, stock: 163, enabled: true, image: "https://products0.imgix.drizly.com/ci-bud-light-19699dcd3e7591e3.png?auto=format%2Ccompress&fm=jpeg&q=20")
# @beer_11 = @user_21.items.create(name: "Stella Artois", description: "Pale lager, 5%", item_price: 5.25, stock: 113, enabled: true, image: "https://products1.imgix.drizly.com/ci-stella-artois-f4762eb0a31c5839.jpeg?auto=format%2Ccompress&fm=jpeg&q=20")
# @beer_12 = @user_22.items.create(name: "Dos Equis", description: "Lager, 4.2%", item_price: 3.75, stock: 139, enabled: true, image: "https://products1.imgix.drizly.com/ci-dos-equis-lager-47ccc594ec8ef07a.jpeg?auto=format%2Ccompress&fm=jpeg&q=20")
# @beer_13 = @user_23.items.create(name: "Pabst Blue Ribbon", description: "Lager, 4.7%", item_price: 3.75, stock: 162, enabled: true, image: "https://products3.imgix.drizly.com/ci-pabst-blue-ribbon-16cdc21d4cdd2998.jpeg?auto=format%2Ccompress&fm=jpeg&q=20")
# @beer_14 = @user_24.items.create(name: "Miller Genuine Draft", description: "Lager, 4.6%", item_price: 4.25, stock: 65, enabled: true, image: "https://products2.imgix.drizly.com/ci-miller-genuine-draft-07df3f0e01e86665.jpeg?auto=format%2Ccompress&fm=jpeg&q=20")
# @beer_15 = @user_25.items.create(name: "Michelob Ultra", description: "Lite lager, 4.2%", item_price: 4.50, stock: 181, enabled: false, image: "https://products3.imgix.drizly.com/ci-michelob-ultra-73549a7431b0a47e.jpeg?auto=format%2Ccompress&fm=jpeg&q=20")
#
# #orders
# @order_1 = @user_11.orders.create(status: 0)
# @order_2 = @user_12.orders.create(status: 0)
# @order_3 = @user_13.orders.create(status: 0)
# @order_4 = @user_14.orders.create(status: 0)
# @order_5 = @user_15.orders.create(status: 1, created_at: 10.days.ago, updated_at: 1.day.ago)
# @order_6 = @user_16.orders.create(status: 2, created_at: 9.days.ago, updated_at: 1.day.ago)
# @order_7 = @user_11.orders.create(status: 2, created_at: 8.days.ago, updated_at: 1.day.ago)
# @order_8 = @user_12.orders.create(status: 2, created_at: 7.days.ago, updated_at: 1.day.ago)
# @order_9 = @user_13.orders.create(status: 2, created_at: 6.days.ago, updated_at: 1.day.ago)
# @order_10 = @user_14.orders.create(status: 3)
#
# #order_items
# @oi_1 = OrderItem.create(fulfilled: false, quantity: 3, order_price: 2, order_id: @order_1.id, item_id: @beer_1.id, created_at: 10.days.ago, updated_at: 1.day.ago)
# @oi_2 = OrderItem.create(fulfilled: false, quantity: 4, order_price: 3, order_id: @order_1.id, item_id: @beer_2.id, created_at: 10.days.ago, updated_at: 1.day.ago)
# @oi_3 = OrderItem.create(fulfilled: false, quantity: 5, order_price: 4, order_id: @order_2.id, item_id: @beer_3.id, created_at: 8.days.ago, updated_at: 1.day.ago)
# @oi_4 = OrderItem.create(fulfilled: false, quantity: 6, order_price: 5, order_id: @order_4.id, item_id: @beer_1.id, created_at: 7.days.ago, updated_at: 1.day.ago)
# @oi_5 = OrderItem.create(fulfilled: false, quantity: 7, order_price: 2, order_id: @order_5.id, item_id: @beer_6.id, created_at: 6.days.ago, updated_at: 1.day.ago)
# @oi_6 = OrderItem.create(fulfilled: false, quantity: 8, order_price: 3, order_id: @order_5.id, item_id: @beer_7.id, created_at: 6.days.ago, updated_at: 1.day.ago)
# @oi_7 = OrderItem.create(fulfilled: false, quantity: 9, order_price: 4, order_id: @order_7.id, item_id: @beer_8.id, created_at: 5.days.ago, updated_at: 1.day.ago)
# @oi_8 = OrderItem.create(fulfilled: false, quantity: 3, order_price: 5, order_id: @order_7.id, item_id: @beer_10.id, created_at: 5.days.ago, updated_at: 1.day.ago)
# @oi_9 = OrderItem.create(fulfilled: false, quantity: 4, order_price: 2, order_id: @order_6.id, item_id: @beer_4.id, created_at: 4.days.ago, updated_at: 1.day.ago)
# @oi_10 = OrderItem.create(fulfilled: false, quantity: 5, order_price: 3, order_id: @order_6.id, item_id: @beer_1.id, created_at: 4.days.ago, updated_at: 1.day.ago)
# @oi_11 = OrderItem.create(fulfilled: true, quantity: 6, order_price: 4, order_id: @order_6.id, item_id: @beer_13.id, created_at: 4.days.ago, updated_at: 1.day.ago)
# @oi_12 = OrderItem.create(fulfilled: true, quantity: 7, order_price: 5, order_id: @order_3.id, item_id: @beer_12.id, created_at: 2.days.ago, updated_at: 1.day.ago)
# @oi_13 = OrderItem.create(fulfilled: true, quantity: 8, order_price: 2, order_id: @order_3.id, item_id: @beer_14.id, created_at: 2.days.ago, updated_at: 1.day.ago)
# @oi_14 = OrderItem.create(fulfilled: true, quantity: 9, order_price: 3, order_id: @order_8.id, item_id: @beer_1.id, created_at: 6.days.ago, updated_at: 1.day.ago)
# @oi_15 = OrderItem.create(fulfilled: true, quantity: 1, order_price: 4, order_id: @order_9.id, item_id: @beer_15.id, created_at: 10.days.ago, updated_at: 1.day.ago)

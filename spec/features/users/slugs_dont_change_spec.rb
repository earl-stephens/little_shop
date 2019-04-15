require "rails_helper"

describe 'when a user alters his profile' do
  it 'the slug doesnt change based on an email change' do
    user = User.create!(name: "Joe", email: "joe@gmail.com", password_digest: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345", slug: "joe-gmail.com")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/users/joe-gmail-com'

    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content("Role: #{user.role}")
    expect(page).to have_content("Address: #{user.address}")
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)

    click_link "Edit"

    fill_in :user_email, with: "joe@hotmail.com"

    click_button "Submit"

    user.reload
    expect(current_path).to eq(profile_path)

    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content("Role: #{user.role}")
    expect(page).to have_content("Address: #{user.address}")
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)

    #verify that slug has changed and goes to a new path
    visit '/users/joe-hotmail-com'

    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content("Role: #{user.role}")
    expect(page).to have_content("Address: #{user.address}")
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
  end

  it 'the slug doesnt change based on other attribute changes' do
    user = User.create!(name: "Joe", email: "joe@gmail.com", password_digest: "password", address: "123 Main", city: "Charleston", state: "SC", zip: "12345", slug: "joe-gmail.com")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/users/joe-gmail-com'

    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content("Role: #{user.role}")
    expect(page).to have_content("Address: #{user.address}")
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)

    click_link "Edit"

    fill_in :user_name, with: "Jake"
    fill_in :user_address, with: "456 South Street"
    fill_in :user_city, with: "Seattle"
    fill_in :user_state, with: "WA"
    fill_in :user_zip, with: "98315"
    fill_in :user_password, with: "abc123"
    fill_in :user_password_confirmation, with: "abc123"

    click_button "Submit"

    user.reload

    #slug should not have changed during the update
    visit '/users/joe-gmail-com'

    expect(page).to have_content("Email: #{user.email}")
    expect(page).to have_content("Role: #{user.role}")
    expect(page).to have_content("Address: #{user.address}")
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
  end
end

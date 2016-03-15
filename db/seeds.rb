User.create!(name: "Foo Bar", email: "foo@bar.baz", password: "secret", password_confirmation: "secret")

99.times do |n|
  User.create!(name: Faker::Name.name, email: Faker::Internet.free_email, password: "secret", password_confirmation: "secret")
end

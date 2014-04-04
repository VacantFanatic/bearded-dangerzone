namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Employee.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 userid: "uxd001",
                 password: "foobar",
                 password_confirmation: "foobar"
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      userid = "axz0#{n+1}"
      password  = "password"
      admin = false
      Employee.create!(name: name,
                   email: email,
                   userid: userid,
                   password: password,
                   password_confirmation: password
                   admin: admin)
    end
  end
end
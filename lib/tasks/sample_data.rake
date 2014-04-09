namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Employee.create!(name: "Aran Gillmore",
                 email: "example@railstutorial.org",
                 userid: "axg768",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      userid = "axz0#{n+1}"
      password  = "password"
      Employee.create!(name: name,
                   email: email,
                   userid: userid,
                   password: password,
                   password_confirmation: password)
    end
    
    employees = Employee.all(limit: 6)
    50.times do
      event_type = "Compressed"
      start_date =  Date.today + rand(30).days 
      end_date =    start_date + (1 + rand(90)).days 
      employees.each { |employee| employee.events.create!(event_type: event_type, start_date: start_date, end_date: end_date) }
    end
    
  end
end
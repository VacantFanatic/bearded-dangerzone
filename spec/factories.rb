FactoryGirl.define do
  factory :employee do
    sequence(:name)    { |n| "Person #{n}"  }
    sequence(:userid)  { |n| "uxd00#{n}"    }
    sequence(:email)   { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  
  factory :event do
    event_type "Lorem ipsum"
    start_date { Date.today - rand(500).days }
    end_date { start_date + (1 + rand(1000)).days }
    employee
  end
  
end
FactoryGirl.define do
  factory :employee do
    name     "Michael Hartl"
    email    "michael@example.com"
    userid   "mxh123"
    password "foobar"
    password_confirmation "foobar"
  end
end
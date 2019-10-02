FactoryBot.define do
  factory :account, class: 'Account' do

    sequence(:email)  {|n| "example#{n}@example.com"}
    gen_pass = Account.generate_valid_password
    password { gen_pass }
    password_confirmation { gen_pass }
    sequence(:authentication_token) {|n| "j#{n}-#{n}DwiJY4XwSnmywdMW"}
  end
end

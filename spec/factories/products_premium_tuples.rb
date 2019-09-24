FactoryBot.define do
  factory :products_premium_tuple, class: '::Products::PremiumTuple' do
    age    { 20 }
    cost  { 200 }
  end
end

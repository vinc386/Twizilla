Factory.define :user do |user|
  user.name                   "foobar" 
  user.email                  "foobar@twizilla.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n+1}@twzilla.com"
end

Factory.define :micropost do |mp|
  mp.content "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
  mp.association :user
end
require 'faker'

namespace :db do
  desc "fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "myself",
                  :email => 'vincent.yang@jgospel.net',
                  :password => 'twizilla',
                  :password_confirmation => 'twizilla')
    149.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@twizilla.com"
      password = 'password'
      User.create!( :name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    end
  end
  
end
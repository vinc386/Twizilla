require 'faker'
namespace :db do
  desc "fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "admin",
                  :email => 'vincent.yang@jgospel.net',
                  :password => 'twizilla',
                  :password_confirmation => 'twizilla')
    admin.toggle!(:admin)
    
    249.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@user.com"
      password = 'foobar'
      User.create!( :name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    end
  end
  
end
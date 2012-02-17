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
    
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@user.com"
      password = 'foobar'
      User.create!( :name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    end
    
    # for microposts
    
    User.all(:limit => 6).each do |u|
      50.times do
        u.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
  
end
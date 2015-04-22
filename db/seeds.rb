# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Seed Questions:

  # When does the service start?
  # What time is the service?
  # How do I get there?
  # Where do I park?
  # How do I contact ___.
  # Is there child care
  # Is there parking
  # Is there coffee
  # Is there baby care
  # Is there communion
  # What time does the service start
  # Where are you located
  # Who is the pastor
  # What denomination is the church


  @user = FactoryGirl.create(:user, email:'dev@cornerstonesf.org', password:'password', admin:true)
  
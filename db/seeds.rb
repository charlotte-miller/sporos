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

# =============================================
# =       Ministries Roles Users & Posts      =
# =============================================
  @mens_ministry, @womens_ministry, @rendezvous_ministry, @teens_ministry, @kids_ministry, @outreach_ministry = @ministries = {
    men:        "A ministry for the men of Cornerstone",
    women:      "A ministry for the women of Cornerstone",
    rendezvous: "Rendezvous is the young adult ministry of Cornerstone Church of San Francisco geared for adults in their 20s/30s who share the same values. Social. Spiritual. Service. This is what we’re about: making social connections, growing spiritually, and giving of ourselves in service to others.",
    teens:      "Join us each week for our Sunday Youth Services! It's the place to be. To feel at home, relax, enjoy, receive, serve, be served, engage, have fun, bring friends, make friends, play games, learn about Jesus, worship God through music, and join a family of teens at Cornerstone! We would LOVE to see you there.",
    kids:       "Each weekend your child, newborn through sixth grade, can be a part of an exciting and active environment filled with songs, games, and activities that teach Godly values at an age-appropriate level. Our weekend children’s services meet at the same time as adult Sunday services, so while you are experiencing the creative, engaging worship and fellowship of Cornerstone, your children are experiencing it as well.",
    outreach:   "We believe that as Christ followers we display Christ's love through caring for the least of these. (Matthew 25:40)"
  }.map {|name,description| Ministry.find_by(name:name) || FactoryGirl.create(:ministry, name:name, description:description) }


  # Editors
  @chip     = User.find_by(first_name:'Chip'    ) || FactoryGirl.create(:user, first_name:'Chip',     last_name:'Miller',   email:'chip@cornerstonesf.org',     password:'Dearborn',  admin:true)
  @rick     = User.find_by(first_name:'Rick'    ) || FactoryGirl.create(:user, first_name:'Rick',     last_name:'Narvarte', email:'rick@cornerstonesf.org',     password:'Dearborn',  admin:true)
  @gretchen = User.find_by(first_name:'Gretchen') || FactoryGirl.create(:user, first_name:'Gretchen', last_name:'Wanger',   email:'gretchen@cornerstonesf.org', password:'Dearborn')             
  @digital_team = [@chip, @gretchen, @rick]
  @digital_team.each do |member|
    next if member.ministries.present?
    member.ministries << @ministries
    member.involvements.each(&:editor!)
  end
  
  
  # Ministry Users and Posts
  @ministries.each do |ministry|
    slug = ministry.slug
    users_found_or_created = { 
      "@#{slug}_member"    => (User.find_by(email:"#{slug}_member@example.com"   ) || FactoryGirl.create(:user, email:"#{slug}_member@example.com",    password:'Dearborn')),
      "@#{slug}_volunteer" => (User.find_by(email:"#{slug}_volunteer@example.com") || FactoryGirl.create(:user, email:"#{slug}_volunteer@example.com", password:'Dearborn')),
      "@#{slug}_leader"    => (User.find_by(email:"#{slug}_leaders@example.com"  ) || FactoryGirl.create(:user, email:"#{slug}_leaders@example.com",   password:'Dearborn'))}
    users_found_or_created.each &method(:instance_variable_set)
    
    member, volunteer, leader = users_found_or_created.values
    ministry.members    << member     unless ministry.members.present?
    ministry.volunteers << volunteer  unless ministry.volunteers.present?
    ministry.leaders    << leader     unless ministry.leaders.present?
    
    if ministry.posts.empty?
      post_factory_type = [:post_event, :post_link, :post_page, :post_photo, :post_video ]
      instance_variable_set "@#{slug}_posts", posts = [
        6.times.map { FactoryGirl.create(post_factory_type.sample, author:volunteer, ministry:ministry) },
        6.times.map { FactoryGirl.create(post_factory_type.sample, author:leader,    ministry:ministry) },
      ].flatten
      posts.each do |post|
        approver = post.approval_requests.sample
        approver.comment_threads << rand(0..5).times.map { FactoryGirl.create(:comment, user:approver.user) }
      end
    end
  end

# Cornerstone Sporos
From the Greek for 'seed', Sporos is a digital version of the Parable of the Sower (Matthew 13).

## How Can I Help?
> The Christian shoemaker does his duty not by putting little crosses on the shoes, but by making good shoes, because God is interested in good craftsmanship. - Martin Luther  

This project uses a number of popular open source frameworks includeing [Twitter Bootstrap](http://getbootstrap.com/), [Backbone.js](http://backbonejs.org), [Ruby on Rails](http://rubyonrails.org/), and [Elastic Search](http://www.elasticsearch.org/).  These projects are well documented, and make it easy to jump-in and start contirbuting!

### Local Setup
**If you have never used Ruby on Rails** you will need to [setup your local machine](https://github.com/cornerstone-sf/sporos/wiki/Rails-Setup) before getting started.

Install Dependancies:
```
gem install bundler
bundle install
```

Setup the Database:
```
rake db:create
rake db:setup
```

Start the Development Environment:
```
guard
rails s
```
**Click here to open your [development server](http://localhost:3000)** (localhost:3000)

# Cornerstone Sporos
From the Greek for 'seed', Sporos is a digital version of the Parable of the Sower (Matthew 13).

## Development
The project is a [Ruby on Rails](http://rubyonrails.org/) app.  If you are new to Ruby or Rails, learn more at [Code School](https://www.codeschool.com/paths/ruby).  
**If you have never used Ruby on Rails** you will probably need to setup your local machine. The rest of this seciton should get you started. [Source](https://gorails.com/setup)

#### Install Homebrew
First, we need to install [Homebrew](http://brew.sh/). Homebrew allows us to install and compile software packages easily from source.

Homebrew comes with a very simple install script. When it asks you to install XCode CommandLine Tools, say yes.
```
 ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```
**Tip:** [Cakebrew](https://www.cakebrew.com/) is a nice (but unnecessary) GUI for homebrew

#### Install Ruby
Now that we have Homebrew installed, we can use it to install Ruby.

We're going to use [rbenv](http://rbenv.org/) to install and manage our Ruby versions.

To do this, run the following commands in your Terminal:
```
 brew install rbenv ruby-build rbenv-gemset rbenv-gem-rehash
 # Add rbenv to bash so that it loads every time you open a terminal
 echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
 source ~/.bash_profile

 # Install Ruby 2.1.2 and set it as the default version
 rbenv install 2.1.2
 rbenv global 2.1.2

 ruby -v
 # ruby 2.1.2
```

#### Install MySQL:
You can install [MySQL](http://www.mysql.com/) server and client from Homebrew:
```
brew install mysql
```
Once this command is finished, it gives you a couple commands to run. Follow the instructions and run them:
```
 # To have launchd start mysql at login:
 ln -sfv /usr/local/opt/mysql/*plist ~/Library/LaunchAgents

 # Then to load mysql now:
 launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
By default the mysql user is ``root`` with no password.
**Tip:** I heavily recommmend [Sequel Pro](http://www.sequelpro.com/)

#### Configure Git
We'll be using Git for our version control system so we're going to set it up to match our [Github](https://github.com/cornerstone-sf) account. If you don't already have a Github account, make sure to [register](https://github.com/). It will come in handy for the future.

Replace the name and email address in the following steps with the ones you used for your Github account.

```
 git config --global color.ui true
 git config --global user.name "Chris Oliver"
 git config --global user.email "chris@excid3.com"
 ssh-keygen -t rsa -C "chris@excid3.com"
```
The next step is to take the newly generated SSH key and add it to your Github account. You want to copy and paste the output of the following command and [paste it here](https://github.com/settings/ssh).
```
 cat ~/.ssh/id_rsa.pub
```
Once you've done this, you can check and see if it worked:
```
 ssh -T git@github.com
```
You should get a message like this:
```
 Hi excid3! You've successfully authenticated, but GitHub does not provide shell access.
```
**Tip** I recommend a lite GUI like [GitX](http://rowanj.github.io/gitx/), but there are also full-feature GUIs like [GitHub Mac](https://mac.github.com/) and [Tower](http://www.git-tower.com/)

#### Help!
If you run into problems Google the error... your probably not the first person to have the issue. The ruby community is friendly and there is generally a fix on [Stack Overflow](http://stackoverflow.com/) or [GitHub](https://github.com/)

### Instillation
Install dependancies:
```
gem install bundler
bundle install
```

Setup Database:
```
rake db:create
rake db:setup
```

require 'git'

namespace :deploy do
  
  desc "Roles the master branch back to the last tag or a specified commit"
  task :rollback, [:tag_or_sha]=> :environment do |t, args|
    rollback_to   = args.tag_or_sha || increment_or_decrement_version('-')
    rollback_from = "rollback_from_#{Time.now.to_i}"
    
    announce("Work stashed")                                {`git stash`}
    announce("Checkout Master")                             {`git co master`}
    announce("Saving current master to #{rollback_from}")   {`git branch #{rollback_from}`       }
    announce("Pushing #{rollback_from} (for safe keeping)") {`git push origin #{rollback_from}`  }
    announce("Moving master to #{rollback_to}")             {`git reset #{rollback_to} --hard`   }
    announce("Pushing the rolled back master to GitHub")    {`git push origin master --force`    }
    `gitx`
  end
  
  
  desc "Merges dev into master... Tags and pushes the release"
  task :dev,  [:version]=> [:environment] do |t,args|
    release_version = args.version || increment_or_decrement_version('+')
    
    announce('Stash Work')                        {`git stash`}
    announce('Checkout Master')                   {`git co master`}
    announce('Merge Dev')                         {`git merge dev --ff-only`} 
    announce("Tagged Release #{release_version}") {`git tag #{release_version}`          }
    announce("Pushing to Master")                 {`git push && git push origin #{release_version}`}
    `open https://github.com/cornerstone-sf/sporos/releases`
  end
  
private

  def announce(message)
    puts "[INFO] #{message}"
    yield
  end
  
  def current_version
    git = Git.open(Rails.root)
    git.tags.map(&:name).select {|tag| tag =~ /^v(\d*)\.(\d*)\.(\d*)$/}.last  # Example: v1.0.23
  end
  
  def increment_or_decrement_version(direction='+')
    new_version = current_version.match(/(\d*)$/)[1].to_i.send(direction, 1)
    current_version.sub(/(\d*)$/, new_version.to_s)
  end
  
end
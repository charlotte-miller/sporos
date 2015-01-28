namespace :deploy do
  
  desc "Roles the master branch back to a trusted state - triggers Ninefold Deploy"
  task :rollback_origin_master, [:sha]=> :environment do |t, args|
    raise ArgumentError unless args.sha
    rollto_branch = "rollback_from_#{Time.now.to_i}"
    `git stash`                         && puts( "[INFO] Work stashed")
    `git co master`                     && puts( "[INFO] Checkout Master")
    `git branch #{rollto_branch}`       && puts( "[INFO] Saving current master to #{rollto_branch}")
    `git push origin #{rollto_branch}`  && puts( "[INFO] Pushing #{rollto_branch} to GitHub (for safe keeping)")
    `git reset #{args.sha} --hard`      && puts( "[INFO] Moving master to #{args.sha}")
    `git push origin master --force`    && puts( "[INFO] Pushing the rolled back master to GitHub")
    `gitx`
  end
  
end
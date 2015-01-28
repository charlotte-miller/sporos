namespace :db do
  desc "Rebuild Database"
  task :rebuild => [:environment] do
    [ 'db:drop',     
      'db:create',   
      'db:migrate',  
      'db:test:purge',
      'db:test:load_schema',
      # 'parallel:prepare'
      # 'db:seed'
    ].each { |task| Rake::Task[ task ].execute  } #rescue next
  end
  
  
  desc "Roles the master branch back to a trusted state"
  task :rollback_origin_master, [:sha]=> :environment do |t, args|
    raise ArgumentError unless args.sha
    rollto_branch = "rollback_from_#{Time.now.to_i}"
    `git stash`                         && puts( 'Work stashed')
    `git co master`                     && puts( 'Checkout Master')
    `git branch #{rollto_branch}`       && puts( "Saving current master to #{rollto_branch}")
    `git push origin #{rollto_branch}`  && puts( "Pushing #{rollto_branch} to GitHub (for safe keeping)")
    `git rollback #{args.sha} --hard`   && puts( "Moving master to #{args.sha}")
    `git push origin master --force`    && puts( "Pushing the rolled back master to GitHub")
    `gitx`
  end
end

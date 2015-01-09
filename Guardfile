# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard :bundler do
#   watch('Gemfile')
#   # Uncomment next line if your Gemfile contains the `gemspec' command.
#   # watch(/^.+\.gemspec/)
# end

rspec_options ={
  all_on_start: false,
  # all_after_pass:false,
  cmd: 'zeus test',
  run_all: { cli:"--deprecation-out" } #--profile
}

guard 'rspec', rspec_options do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{spec/factories/.*_factory.rb'})  { |m| "spec/#{m[1]}_spec.rb" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
end


# teaspoon_options = {
#   all_on_start: false,
#   all_after_pass: true
# }
#
# guard :teaspoon, teaspoon_options do
#     watch(%r{^app/assets/.*\.hamlbars$})                          { 'spec/javascripts' }
#
#     # Run All
#     watch(%r{^spec/javascripts/.*_factory\.(js|coffee)$})         { 'spec/javascripts' }
#     watch(%r{^spec/javascripts/helpers(.*)\.(js|coffee)$})        { 'spec/javascripts' }
#     watch(%r{^app/assets/javascripts/([^/]*)\.(js|coffee)$})      { 'spec/javascripts' }
#     watch(%r{^app/assets/javascripts/fixtures(.*)\.(js|coffee)$}) { 'spec/javascripts' }
#
#     # Single Spec
#     watch(%r{^public/javascripts/(.+)\.js$})                    { |m| "specs/#{m[1]}_spec" }
#     watch(%r{^app/assets/javascripts/(.+)\.(js|coffee)$})       { |m| "specs/#{m[1]}_spec" }
#     watch(%r{^spec/javascripts/specs/(.+)_spec\.(js|coffee)$})  { |m| "specs/#{m[1]}_spec" }
#     watch(%r{^lib/assets/javascripts/.*\/(.*)\.(js|coffee)$})   { |m| "specs/lib/#{m[1]}_spec" }
# end

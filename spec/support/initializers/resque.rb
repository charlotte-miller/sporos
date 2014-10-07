# # USAGE:
# #
# #   describe SomeClass, resque: :fake do
# #     # tests
# #   end
# #
# #   describe SomeOtherClass, resque: :inline do
# #     # tests
# #   end
# #
# #
# RSpec.configure do |config|
#   config.before(:each) do
#     # Clears out the jobs for tests using the fake testing
#     ResqueSpec.reset!
#
#     if example.metadata[:resque] == :fake
#       ResqueSpec.disable_ext = false
#     elsif example.metadata[:resque] == :inline
#       ResqueSpec.disable_ext = true
#     elsif example.metadata[:type] == :acceptance
#       ResqueSpec.disable_ext = true
#     else
#       ResqueSpec.disable_ext = false
#     end
#   end
# end
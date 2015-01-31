FriendlyId.defaults do |config|
  config.use :slugged, :history
  config.use :reserved
  # Reserve words for English and Spanish URLs
  config.reserved_words = %w(new edit search library groups info about bible church cornerstone cornerstone-sf) #books audio video studies
end

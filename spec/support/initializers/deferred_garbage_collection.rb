# https://ariejan.net/2011/09/24/rspec-speed-up-by-tweaking-ruby-garbage-collection/
# before: 4m39.221s
# after:  4m21.997s

class DeferredGarbageCollection

  # GC every 15 seconds
  DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 15.0).to_f

  @@last_gc_run = Time.now

  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD > 0
  end

  def self.reconsider
    if DEFERRED_GC_THRESHOLD > 0 && Time.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.now
    end
  end
end

RSpec.configure do |config|
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end

def vcr_lesson_web
  after(:each) { VCR.eject_cassette }
  before(:each) do
    VCR.insert_cassette('lesson_adapters_web', :record => :new_episodes) #:none
  end
end

def vcr_vimeo_upload
  after(:each) { VCR.eject_cassette }
  before(:each) do
    VCR.insert_cassette('vimeo_upload', :record => :new_episodes) #:none
  end
end

def vcr_ignore_localhost
  before(:each) { VCR.request_ignorer.ignore_localhost = true  }
  after(:each)  { VCR.request_ignorer.ignore_localhost = false }
end

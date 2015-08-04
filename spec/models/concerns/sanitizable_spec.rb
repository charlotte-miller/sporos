require 'rails_helper'

describe Sanitizable do
  subject { SanitizableDummy.new }

  describe '#plain_text(str)' do
    before(:all) do
      @html_str = <<-TEXT
        <div>
          <p>
            <a href="javascript://alert('spam')">Friendly Link</a>
            <script>alert('spam')</script>
          </p>
        </div>
      TEXT
    end

    it "strips tags, scripts, and lead/trailing whitespace" do
      expect(subject.send(:plain_text, @html_str)).to eql 'Friendly Link'
    end

    it "whitespace pads the content of the removed tags" do
      [ "<h1>Friendly</h1><p>Link</p>",
        "<h1>Friendly</h1>    <p>Link</p>",
        "<h1>Friendly</h1>\n<p>Link</p>"
      ].each {|str| expect(subject.send(:plain_text, str)).to eql 'Friendly Link' }
    end
  end

  describe '#sanitize(str)' do
    it "removes javascript:// calls" do
      str = <<-TEXT
        <a href="javascript://alert('spam')">Click Me</a>
        <img src="javascript://alert('spam')" />
      TEXT
      clean = subject.send(:sanitize, str)
      expect(clean).to match '<a>Click Me</a>'
      expect(clean).to match '<img>'
    end

    it "removes style attributes" do
      str = <<-TEXT
        <p style="text-size:large;">Click Me</p>
      TEXT
      clean = subject.send(:sanitize, str)
      expect(clean).to eql '<p>Click Me</p>'
    end
  end

  describe '#sanitize_url(str)' do
    it "returns the url as a string" do
      good_url = 'http://www.marshill.org'
      expect(subject.send(:sanitize_url, good_url)).to eql good_url
    end

    it "returns nil when the link is non http(s)" do
      bad_url = "javascript://alert('spam')"
      expect(subject.send(:sanitize_url, bad_url)).to be_nil

      bad_url = "ftp://ftp.example.com"
      expect(subject.send(:sanitize_url, bad_url)).to be_nil
    end
  end

end

class SanitizableDummy
  include Sanitizable
end

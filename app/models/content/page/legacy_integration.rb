module Page::LegacyIntegration
  extend  ActiveSupport::Concern

  def legacy_url(joiner='/')
    slug_chain = []
    ancestor = self

    while ancestor
      slug_chain.unshift ancestor.slug
      ancestor = ancestor.parent
    end
    "/#{slug_chain.join(joiner)}"
  end

  def self.audit_urls
    hydra = Typhoeus::Hydra.new
    all.map(&:legacy_url).each do |path|
      request = Typhoeus::Request.new("http://cornerstone-sf.org#{path}", followlocation: true)
      request.on_complete do |response|
        if response.success?
        else
          error_code = response.code == 404 ? 'Not Found' : response.code.to_s
          puts("#{path} - #{error_code}")
        end
      end
      hydra.queue(request)
    end
    puts '### Starting Audit Now ###'
    hydra.run
    puts '### Audit Complete ###'
  end
end

# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  parent_id    :integer
#  slug         :string           not null
#  title        :string           not null
#  body         :text             not null
#  seo_keywords :text             default("{}"), not null, is an Array
#  hidden_link  :boolean          default("false"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_slug  (slug) UNIQUE
#

class Page < ActiveRecord::Base
  include Sluggable
  slug_candidates :title, [:title, :year], [:title, :month, :year]

  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  

  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates :title, presence:true, length:{in:2..150}
  validates :body,  presence:true, length:{maximum:500_000}
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  def legacy_url
    slug_chain = []
    ancestor = self
    
    while ancestor
      slug_chain.unshift ancestor.slug
      ancestor = ancestor.parent
    end
    slug_chain.join('/')
  end
  
  def self.audit_urls
    hydra = Typhoeus::Hydra.new
    all.map(&:legacy_url).each do |path|
      request = Typhoeus::Request.new("http://cornerstone-sf.org/#{path}", followlocation: true)
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

# == Schema Information
#
# Table name: faqs
#
#  id                :integer          not null, primary key
#  question_variants :text             default("{}"), is an Array
#  answer            :text             not null
#  more_info_path    :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Faq < ActiveRecord::Base
  include Searchable

  searchable_model type: :questions do # [title, display_description, description, keywords, path] are already declaired
    indexes :question_variants,
            analyzer: 'simple',
            fields:{
              autocomplete:{
                type:'completion',
                index_analyzer:'simple',
                search_analyzer:'simple',
                payloads:true,             # {path:'/blah'}
                preserve_separators:true,  #foof != foo fighters
              }
    }

  end

  scope :search_indexable, lambda { }

  def as_indexed_json(options={})
    {
      title:                question_variants[0],
      display_description:  shorter_plain_text(answer),
      path:                 more_info_path,
      description:          plain_text(answer),
      keywords:             [],
    }
  end


end

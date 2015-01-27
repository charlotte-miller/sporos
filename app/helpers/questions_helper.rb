module QuestionsHelper
  
  def polymorphic_questions_path( question_or_action=nil )
    raise ArgumentError.new('requires @lesson or @meeting') unless @lesson || @meeting
    
    question = question_or_action.is_a?( Question ) ? question_or_action : 'questions'
    obj_array = [@study, @lesson, @group, @meeting, question].compact
    
    begin
      case question_or_action
        when 'new'
          obj_array[-1] = obj_array[-1].singularize
          new_polymorphic_path( obj_array )
        # not edit
      
        when Question
          question_path(question) #shallow routes

        else  polymorphic_path( obj_array )
      end
    
    rescue NoMethodError => e
      # Namespaced models like Media::Study create non-existant paths
      # This scrapes the path out of the error and retries w/out the 'media' namespace
      namespaced_method = e.message.match(/\w*_path/)[0]
      obj_array.pop if obj_array[-1].is_a? String
      self.send(namespaced_method.gsub(/media_/,''), *obj_array.map(&:to_param))
    end
  end
end

class StudiesController < ApplicationController
  # caches_page :show

  # GET /library?search=keyword
  # GET /library.json
  def index
    @studies = (
      if params[:search]
        Study.search do
          fulltext params[:search]
        end
        
      else # Not searching
        Study.all
      end
    )
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studies }
    end
  end

  # GET /library/name-of-study
  # GET /library/name-of-study.json
  def show
    @study      = find_or_redirect_to_study || return #redirecting
    @lessons    = @study.lessons
    
    # Users last watched or... for now
    @lesson = @lessons.first
      
    respond_to do |format|      
      format.html { redirect_to study_lesson_url(@study, @lesson) }
      format.json { render json: @study }
    end
  end

private
  
  # Return @study OR follow old friendly_id
  # Usage: @study = find_or_redirect_to_study || return #redirecting
  def find_or_redirect_to_study
    study = Study.w_lessons.friendly.find(params[:id]) 
    unless request.path == study_path(study)
      redirect_to( study_url(study), status: :moved_permanently ) && (return false)
    end
    return study
  end
  
end

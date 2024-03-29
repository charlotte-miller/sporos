class Admin::StudiesController < Admin::BaseController

  # GET /admin/studies?search=keyword
  # GET /admin/studies.json
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

  # GET /admin/studies/name-of-study
  # GET /admin/studies/name-of-study.json
  def show
    @study = Study.friendly.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study }
    end
  end

  # GET /admin/studies/new
  # GET /admin/studies/new.json
  def new
    @study = Study.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @study }
    end
  end

  # GET /admin/studies/1/edit
  def edit
    @study = Study.friendly.find(params[:id])
  end

  # POST /admin/studies
  # POST /admin/studies.json
  def create
    @study = Study.new(params[:study])

    respond_to do |format|
      if @study.save
        format.html { redirect_to admin_study_url(@study), notice: 'Study was successfully created.' }
        format.json { render json: @study, status: :created, location: @study }
      else
        format.html { render action: "new" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/studies/name-of-study
  # PUT /admin/studies/name-of-study.json
  def update
    @study = Study.friendly.find(params[:id])

    respond_to do |format|
      if @study.update_attributes(params[:study])
        format.html { redirect_to admin_study_url(@study), notice: 'Study was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/studies/name-of-study
  # DELETE /admin/studies/name-of-study.json
  def destroy
    @study = Study.friendly.find(params[:id])
    @study.destroy

    respond_to do |format|
      format.html { redirect_to admin_studies_url }
      format.json { head :no_content }
    end
  end
end

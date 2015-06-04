class Admin::UploadedFilesController < Admin::BaseController
  respond_to :json
  
  def index
    @uploaded_files = if set_post
      @post.uploaded_files
    else
      UploadedFile.where(session_id:session.id)
    end
    
    render json: { files: @uploaded_files.order(created_at: :desc).map(&:file_as_json) }
  end
  
  def create
    @uploaded_file = if set_post
      UploadedFile.new(uploaded_file_params.merge( from:set_post ))
    else
      UploadedFile.new(uploaded_file_params.merge( session_id:session.id ))
      # Added by session_id when the post is saved
    end
    
    file = @uploaded_file.file
    if @uploaded_file.save
      # https://github.com/blueimp/jQuery-File-Upload/wiki/JSON-Response
      render json: { files:[ @uploaded_file.file_as_json ]}
    else
      render json: { files:[{
        name: file,
        size: file.try(:size),
        error: @uploaded_file.errors.full_messages
      }]}
    end
  end
  
  def destroy
    set_uploaded_file
    deceased_file_name = @uploaded_file.file.name
    if @uploaded_file.destroy
      render json: { files:[{
        deceased_file_name => true
      }]}
    else
      render json: { files:[{
        deceased_file_name => false
      }]}
    end
  end
  
private
  
  def set_uploaded_file
    uploaded_file      = UploadedFile.find(params[:id])
    this_is_my_upload  = current_user.posts.map(&:id).include?( uploaded_file.from_id ) && (uploaded_file.from_type =~ /^Post/)
    
    unless current_user.admin? || this_is_my_upload
      (redirect_to admin_posts_url and return)
    end
    @uploaded_file ||= uploaded_file
  end
  
  def uploaded_file_params
    @uploaded_file_params ||= params.require(:uploaded_file).permit(:image, :video)
  end
  
  def post_params
    @post_params ||= params.require(:post).permit(:id)
  end
  
  def set_post
    @post ||= unless post_params[:id].blank?
      Post.find(post_params[:id])
    end
  rescue ActionController::ParameterMissing
    nil
  end
end

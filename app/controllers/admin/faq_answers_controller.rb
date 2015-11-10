class Admin::FaqAnswersController < ApplicationController
  before_action :set_admin_faq_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @admin_faq_answers = Admin::FaqAnswer.all
    respond_with(@admin_faq_answers)
  end

  def show
    respond_with(@admin_faq_answer)
  end

  def new
    @admin_faq_answer = Admin::FaqAnswer.new
    respond_with(@admin_faq_answer)
  end

  def edit
  end

  def create
    @admin_faq_answer = Admin::FaqAnswer.new(faq_answer_params)
    flash[:notice] = 'Admin::FaqAnswer was successfully created.' if @admin_faq_answer.save
    respond_with(@admin_faq_answer)
  end

  def update
    flash[:notice] = 'Admin::FaqAnswer was successfully updated.' if @admin_faq_answer.update(faq_answer_params)
    respond_with(@admin_faq_answer)
  end

  def destroy
    @admin_faq_answer.destroy
    respond_with(@admin_faq_answer)
  end

  private
    def set_admin_faq_answer
      @admin_faq_answer = Admin::FaqAnswer.find(params[:id])
    end

    def admin_faq_answer_params
      params.require(:admin_faq_answer).permit(:user, :body)
    end
end

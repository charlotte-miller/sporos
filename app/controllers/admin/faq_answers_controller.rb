class Admin::FaqAnswersController < ApplicationController
  before_action :set_faq_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @faq_answers = FaqAnswer.all
    respond_with(:admin, @faq_answers)
  end

  def show
    respond_with(:admin, @faq_answer)
  end

  def new
    @faq_answer = FaqAnswer.new
    respond_with(:admin, @faq_answer)
  end

  def edit
  end

  def create
    @faq_answer = FaqAnswer.new(faq_answer_params)
    flash[:notice] = 'FaqAnswer was successfully created.' if @faq_answer.save
    respond_with(:admin, @faq_answer)
  end

  def update
    flash[:notice] = 'FaqAnswer was successfully updated.' if @faq_answer.update(faq_answer_params)
    respond_with(:admin, @faq_answer)
  end

  def destroy
    @faq_answer.destroy
    respond_with(:admin, @faq_answer)
  end

  private
    def set_faq_answer
      @faq_answer = FaqAnswer.find(params[:id])
    end

    def faq_answer_params
      params.require(:faq_answer).permit(:user, :body)
    end
end

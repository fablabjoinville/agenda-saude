module Admin
  class InquiryQuestionsController < Base
    before_action :set_inquiry_question, only: %i[show edit update destroy]

    def index
      @inquiry_questions = InquiryQuestion.admin_order
                                          .page(index_params[:page])
                                          .per(100)
    end

    def new
      @inquiry_question = InquiryQuestion.new
    end

    def create
      @inquiry_question = InquiryQuestion.new(inquiry_question_params)

      if @inquiry_question.save
        redirect_to admin_inquiry_question_path(@inquiry_question)
      else
        render :new
      end
    end

    def show
      @inquiry_answers = @inquiry_question.inquiry_answers
                                          .admin_order
                                          .page(index_params[:page])
                                          .per(100)
    end

    def edit; end

    def update
      if @inquiry_question.update(inquiry_question_params)
        redirect_to admin_inquiry_question_path(@inquiry_question)
      else
        render :edit
      end
    end

    def destroy
      @inquiry_question.destroy!
      redirect_to admin_inquiry_questions_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def inquiry_question_params
      params.require(:inquiry_question).permit(:text, :form_type, :position, :active)
    end

    def set_inquiry_question
      @inquiry_question = InquiryQuestion.find(params[:id])
    end
  end
end

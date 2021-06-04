module Admin
  class InquiryAnswersController < Base
    before_action :set_inquiry_question
    before_action :set_inquiry_answer, only: %i[show edit update destroy]

    def index
      redirect_to([:admin, @inquiry_question])
    end

    def new
      @inquiry_answer = @inquiry_question.inquiry_answers.build
    end

    def create
      @inquiry_answer = @inquiry_question.inquiry_answers.build(inquiry_answer_params)

      if @inquiry_answer.save
        redirect_to([:admin, @inquiry_question, @inquiry_answer])
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @inquiry_answer.update(inquiry_answer_params)
        redirect_to([:admin, @inquiry_question, @inquiry_answer])
      else
        render :edit
      end
    end

    def destroy
      @inquiry_answer.destroy!
      redirect_to([:admin, @inquiry_question])
    end

    private

    def index_params
      params.permit(:page)
    end

    def inquiry_answer_params
      params.require(:inquiry_answer).permit(:text, :position, :active)
    end

    def set_inquiry_answer
      @inquiry_answer = @inquiry_question.inquiry_answers.find(params[:id])
    end

    def set_inquiry_question
      @inquiry_question = InquiryQuestion.find(params[:inquiry_question_id])
    end
  end
end

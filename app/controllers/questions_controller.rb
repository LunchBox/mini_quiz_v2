class QuestionsController < ApplicationController
  before_action :set_quiz, only: %i[ index new create ]
  before_action :set_question, only: %i[ show edit update up down destroy ]

  # GET /questions or /questions.json
  def index
    @questions = @quiz.questions.by_seq
  end

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new score: 1
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)
    @question.quiz = @quiz
    @question.user = current_user

    respond_to do |format|
      if @question.save
        format.html { redirect_to question_url(@question), notice: "Question was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def up
    @question.quiz.reset_questions_seq
    @question.move_higher

    respond_to do |format|
      format.html { redirect_to [@quiz, :questions], notice: "Question was successfully updated." }
    end
  end

  def down
    @question.quiz.reset_questions_seq
    @question.move_lower

    respond_to do |format|
      format.html { redirect_to [@quiz, :questions], notice: "Question was successfully updated." }
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_url(@question), notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url, notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    def set_quiz
      @quiz = Quiz.find_by! permalink: params[:quiz_id]
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.fetch(:question, {}).permit(:subject, :score, :fixed_options, :desc, :batch_options, {correct_options: []})
    end
end

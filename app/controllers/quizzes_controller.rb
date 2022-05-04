class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show moniter edit update destroy ]

  # GET /quizzes or /quizzes.json
  def index
    @quizzes = Quiz.order id: :desc
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes or /quizzes.json
  def create
    @quiz = Quiz.new(quiz_params)

    @quiz.user = current_user

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully created." }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to quiz_url(@quiz), notice: "Quiz was successfully updated." }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  def clone
    target = Quiz.find params[:id]
    @quiz = target.deep_clone!

    respond_to do |format|
      format.html { redirect_to [:edit, @quiz], notice: 'Quiz was successfully cloned.' }
    end
  end


  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy

    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find_by! permalink: params[:id]
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.fetch(:quiz, {}).permit(
        :title, 
        :desc, 
        :calc_type, 
        :pre_notice, 
        :published_at, 
        :anonymous, 
        :result_viewable,
        :shuffle_options, 
        :shuffle_questions,
        :on_schedule,
        :start_at,
        :end_at
      )
    end
end

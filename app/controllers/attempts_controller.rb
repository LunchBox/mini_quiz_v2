class AttemptsController < ApplicationController

  before_action :set_quiz, only: %i[ index new create ]
  before_action :set_attempt, only: %i[ show edit update destroy ]
	skip_before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :notice, :unavailable]

  # GET /attempts or /attempts.json
  def index
    if @quiz.on_schedule
      @attempts = @quiz.attempts
    else
      # @attempts = Attempt.rank @quiz.attempts
      @pagy, @attempts = pagy(@quiz.attempts)
    end
  end

  # GET /attempts/1 or /attempts/1.json
  def show
    unless @attempt.quiz.result_viewable
      authenticate_user!
    end
  end

  # GET /attempts/new
  def new
		respond_to do |format|
			if @quiz.published?
				@attempt = Attempt.new
				@attempt.quiz = @quiz

				format.html { render :new }
			else
				format.html { redirect_to [:unavailable, :attempts] }
			end
		end

  end

  # GET /attempts/1/edit
  def edit
		@quiz = @attempt.quiz

    if @quiz.step_by_step
      @step = params[:s].to_i

      @attempt_answer = @attempt.attempt_answers[@step]
      @question = @attempt_answer.question

      @prev = @attempt.attempt_answers[@step - 1]
      @next = @attempt.attempt_answers[@step + 1]
    end

    respond_to do |format|
      if !@attempt.submitted?
        format.html { render :edit }
      else
        format.html { redirect_to [:unavailable, :attempts] }
      end
    end
  end

  # POST /attempts or /attempts.json
  def create
    @attempt = Attempt.new(attempt_params)
    @attempt.quiz = @quiz

    respond_to do |format|
      if @attempt.save
        @attempt.start!
        format.html { redirect_to [:edit, @attempt] }
        format.json { render :show, status: :created, location: @attempt }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attempts/1 or /attempts/1.json
  def update
		respond_to do |format|
			if @attempt.update(attempt_params)
				@attempt.submit!
        target = @attempt.quiz.result_viewable ? @attempt : [:notice, :attempts]
				format.html { redirect_to target }
				format.json { render :show, status: :ok, location: @attempt }
			else
				format.html { render :edit }
				format.json { render json: @attempt.errors, status: :unprocessable_entity }
			end
		end
  end

  # DELETE /attempts/1 or /attempts/1.json
  def destroy
    @attempt.destroy

    respond_to do |format|
      format.html { redirect_to attempts_url, notice: "Attempt was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt
      @attempt = Attempt.find_by! permalink: params[:id]
    end

    def set_quiz
      @quiz = Quiz.find_by! permalink: params[:quiz_id]
    end

    # Only allow a list of trusted parameters through.
    def attempt_params
      params.fetch(:attempt, {}).permit(:name, {attempt_answers_attributes: [:id, :selected_option, selected_options: []]})
    end
end

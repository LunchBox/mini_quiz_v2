class AttemptsController < ApplicationController
  before_action :set_quiz, only: %i[ index new create ]
  before_action :set_attempt, only: %i[ show edit update destroy ]
	skip_before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :notice, :unavailable]

  # GET /attempts or /attempts.json
  def index
    @attempts = Attempt.rank @quiz.attempts
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
			if @quiz.available?
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

    respond_to do |format|
      if @attempt.valid_auth_code?(params[:auth_code])
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
    @attempt.start_at = Time.now
    @attempt.gen_auth_code

    @quiz.questions.each do |q|
      aa = @attempt.attempt_answers.build
      aa.question = q
    end


    respond_to do |format|
      if @attempt.save
        format.html { redirect_to [:edit, @attempt, auth_code: @attempt.auth_code], notice: "Attempt was successfully created." }
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
			if @attempt.valid_auth_code?(params[:auth_code]) and @attempt.update(attempt_params)
				@attempt.submit!
        target = @attempt.quiz.result_viewable ? @attempt : [:notice, :attempts]
				format.html { redirect_to target, notice: 'Attempt was successfully updated.' }
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
      @attempt = Attempt.find(params[:id])
    end

    def set_quiz
      @quiz = Quiz.find_by! permalink: params[:quiz_id]
    end

    # Only allow a list of trusted parameters through.
    def attempt_params
      params.fetch(:attempt, {}).permit(:name, {attempt_answers_attributes: [:id, :question_id, {selected_options: []}]})
    end
end

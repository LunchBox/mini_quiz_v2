class AttemptAnswersController < ApplicationController
  before_action :set_attempt_answer, only: %i[ show edit update destroy ]

  # GET /attempt_answers or /attempt_answers.json
  def index
    @attempt_answers = AttemptAnswer.all
  end

  # GET /attempt_answers/1 or /attempt_answers/1.json
  def show
  end

  # GET /attempt_answers/new
  def new
    @attempt_answer = AttemptAnswer.new
  end

  # GET /attempt_answers/1/edit
  def edit
  end

  # POST /attempt_answers or /attempt_answers.json
  def create
    @attempt_answer = AttemptAnswer.new(attempt_answer_params)

    respond_to do |format|
      if @attempt_answer.save
        format.html { redirect_to attempt_answer_url(@attempt_answer), notice: "Attempt answer was successfully created." }
        format.json { render :show, status: :created, location: @attempt_answer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attempt_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attempt_answers/1 or /attempt_answers/1.json
  def update
    respond_to do |format|
      if @attempt_answer.update(attempt_answer_params)
        format.html { redirect_to attempt_answer_url(@attempt_answer), notice: "Attempt answer was successfully updated." }
        format.json { render :show, status: :ok, location: @attempt_answer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attempt_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attempt_answers/1 or /attempt_answers/1.json
  def destroy
    @attempt_answer.destroy

    respond_to do |format|
      format.html { redirect_to attempt_answers_url, notice: "Attempt answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt_answer
      @attempt_answer = AttemptAnswer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attempt_answer_params
      params.fetch(:attempt_answer, {})
    end
end

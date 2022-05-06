class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show moniter clone clear_attempts clear_questions edit update import destroy ]

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
    target = @quiz
    @quiz = target.deep_clone!

    respond_to do |format|
      format.html { redirect_to [:edit, @quiz], notice: 'Quiz was successfully cloned.' }
    end
  end

  def clear_attempts
    @quiz.attempts.destroy_all

    respond_to do |format|
      format.html { redirect_to [@quiz, :attempts], notice: 'Attempts have been cleared.' }
    end
  end

  def clear_questions
    @quiz.questions.destroy_all
    @quiz.attempts.destroy_all

    respond_to do |format|
      format.html { redirect_to [@quiz, :questions], notice: 'Questions have been cleared.' }
    end
  end

	def import
		xlsx = Roo::Spreadsheet.open params[:excel].tempfile


    ActiveRecord::Base.transaction do
      xlsx.each_with_pagename do |name, sheet|
        sheet.each_row_streaming(pad_cells: true, offset: 1) do |row|
          fr = lambda {|col| row[col].value.try :strip}
          question = @quiz.questions.new subject: fr.call(1)
          question.question_options.build content: fr.call(3)
          question.question_options.build content: fr.call(4)
          question.question_options.build content: fr.call(5)
          question.question_options.build content: fr.call(6)
          question.user = current_user
          question.score = 1
          question.save!

          question.correct_options = question.question_options.select{|qo| qo.content == fr.call(2)}.map(&:id).map(&:to_s)
          question.save!
        end
      end
		end

    respond_to do |format|
      format.html { redirect_to [@quiz, :questions], notice: 'questions imported.' }
    end
	end


  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy

    respond_to do |format|
      format.html { redirect_to :quizzes, notice: "Quiz was successfully destroyed." }
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
        :published, 
        :anonymous, 
        :result_viewable,
        :shuffle_options, 
        :shuffle_questions,
        :on_schedule,
        :start_at,
        :duration
      )
    end
end

class Quiz < ApplicationRecord
	belongs_to :user

	has_many :questions, dependent: :destroy

	has_many :attempts, dependent: :destroy

	validates :title, presence: true, uniqueness: true
  validates_uniqueness_of :permalink

	CALC_TYPES = ["full_match", "part_match"]

	def to_s
		self.title
	end

  def to_param
    self.permalink
  end

  def reset_questions_seq
    self.questions.by_seq.each_with_index do |q, i|
      q.update seq: i
    end
  end

	before_save :make_permalink
	def make_permalink
		return unless self.permalink.blank?
		loop do
			# this can create permalink with random 8 digit alphanumeric
			self.permalink = SecureRandom.urlsafe_base64(4)
			break self.permalink unless Quiz.where(permalink: self.permalink).exists?
		end
	end

	def deep_clone!
		ActiveRecord::Base.transaction do
			new_quiz = self.dup
			new_quiz.title += " [clone: #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}]"
      new_quiz.permalink = nil
			new_quiz.published = false

			self.questions.each do |question|
				new_question = question.dup

				correct_options = []
				question.question_options.each do |question_option|
					new_question_option = question_option.dup

					new_question.question_options << new_question_option
					if question.correct_options.try(:"include?", question_option.id.to_s)
						correct_options << new_question_option
					end
				end

				new_question.save!
				new_question.correct_options = correct_options.map(&:id).map(&:to_s)
				new_question.save!

				new_quiz.questions << new_question
			end
			new_quiz.save!
			new_quiz
		end
	end

end

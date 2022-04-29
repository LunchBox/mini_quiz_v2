class Quiz < ApplicationRecord
	belongs_to :user

	has_many :questions, dependent: :destroy

	has_many :attempts, dependent: :destroy

	validates :title, presence: true, uniqueness: true

	CALC_TYPES = ["full_match", "part_match"]

	def to_s
		self.title
	end

	def deep_clone!
		ActiveRecord::Base.transaction do
			new_quiz = self.dup
			new_quiz.title += " [clone: #{(0...8).map { ('a'..'z').to_a[rand(26)] }.join}]"
			new_quiz.available = false

			self.questions.each do |question|
				new_question = question.dup
				new_question.image = question.image

				correct_options = []
				question.question_options.each do |question_option|
					new_question_option = question_option.dup
					new_question_option.image = question_option.image

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

class Attempt < ApplicationRecord
	belongs_to :quiz
	has_many :attempt_answers, dependent: :destroy
	accepts_nested_attributes_for :attempt_answers

	validates :name, presence: true
	validates :school, presence: true
	validates :mobile, presence: true

	# scope :by_default, -> {order("score desc, time_diff asc")}

	def self.rank attempts
		attempts.sort_by{|att| [-att.calc_score[:score], att.time_diff.blank? ? 999999999 : att.time_diff ]}
	end

	def valid_auth_code? code
		!code.blank? and code == self.auth_code
	end

	def gen_auth_code
		self.auth_code = (0...32).map { ('a'..'z').to_a[rand(26)] }.join
	end

	def clear_auth_code!
		self.auth_code = nil
		self.end_at = Time.now
		self.save!
	end

	before_save :record_time_diff
	def record_time_diff
		if self.end_at and self.start_at
			self.time_diff = self.end_at - self.start_at
		end
	end

	# before_save :record_score
	# def record_score
	#     res = self.calc_score
	#     self.score = res[:score]
	# end

	def formatted_diff
		if self.end_at and self.start_at
			df = self.end_at - self.start_at
			df > 60 ? "#{df.to_i / 60} mins #{(df % 60).round} sec" : "#{(df % 60).round} sec"
		end
	end

	def calc_score
		correct_count = 0
		s = 0

		self.attempt_answers.each do |aa|
			res = aa.calc_score(aa.question.correct_options, self.quiz.calc_type, aa.question.score)
			if res and res > 0
				correct_count += 1
				s += res
			end
		end

		# case self.quiz.calc_type
		# when "part_match"
		#     self.attempt_answers.each do |aa|
		#         next if aa.question.correct_options.blank?
		#         next if aa.selected_options.blank?

		#         if (aa.question.correct_options | aa.selected_options) == aa.question.correct_options
		#             correct_count += 1
		#             s += ((aa.selected_options.size.to_f / aa.question.correct_options.size) * aa.question.score).round(2)
		#         end
		#     end
		# else
		#     self.attempt_answers.each do |aa|
		#         if aa.selected_options == aa.question.correct_options
		#             correct_count += 1
		#             s += aa.question.score
		#         end
		#     end
		# end

		{correct_count: correct_count, score: s}
	end

	def formatted_score
		res = self.calc_score

		"#{res[:correct_count]} / #{self.quiz.questions.size}; score: #{res[:score]}"
	end

end

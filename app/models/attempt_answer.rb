class AttemptAnswer < ApplicationRecord
	belongs_to :attempt
	belongs_to :question

	serialize :selected_options


	def calc_score correct_options, calc_type, score
		return if correct_options.blank?
		return if self.selected_options.blank?

		case calc_type
		when "part_match"
			if (correct_options | self.selected_options) == correct_options
				return ((self.selected_options.size.to_f / correct_options.size) * score).round(2)
			end
		else
			if self.selected_options == correct_options
				return score
			end
		end
		nil
	end

end

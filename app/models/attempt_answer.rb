class AttemptAnswer < ApplicationRecord
	belongs_to :attempt
	belongs_to :question

	serialize :selected_options

  scope :by_seq, -> { order seq: :asc }

  attr_accessor :selected_option
  def selected_option= val
    if val.blank?
      self.selected_options = []
    else
      self.selected_options = [val.strip]
    end
  end

  def has_answer?
    self.selected_options.try(:size).to_i > 0
  end


	def calc_score correct_options, calc_type, score
		return if correct_options.blank?
		return if self.selected_options.blank?

    if self.selected_options.is_a? Array
      # 選了非答案的選項
      return if (self.selected_options - correct_options).size > 0

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
    else
      if self.selected_options == correct_options
        return score
      end
    end
		nil
	end

end

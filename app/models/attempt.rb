class Attempt < ApplicationRecord
  include RailsStateMachine::Model

  state_machine do
    state :pending, initial: true
    state :preparing
    state :answering
    state :submitted

    event :prepare do
      transitions from: [:pending], to: :preparing
    end

    event :start do
      transitions from: :preparing, to: :answering
    end

    event :submit do
      transitions from: :answering, to: :submitted
    end
  end

  belongs_to :quiz
  has_many :attempt_answers, dependent: :destroy
  accepts_nested_attributes_for :attempt_answers

  validates :name, presence: true

  # scope :by_default, -> {order("score desc, time_diff asc")}
  broadcasts_to ->(attempt) { "attempts_quiz_#{attempt.quiz_id}" }, target: "attempt_list_real"

  def to_s
    self.name
  end

  def self.rank attempts
    attempts.sort_by{|att| [-att.calc_score[:score], att.time_diff.blank? ? 999999999 : att.time_diff ]}
  end

  def valid_auth_code? code
    !code.blank? and code == self.auth_code
  end

  CODE_RANGE = (0..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  CODE_RANGE_SIZE = CODE_RANGE.size

  def gen_auth_code
    # self.auth_code = (0...32).map { ('a'..'z').to_a[rand(26)] }.join
    self.auth_code = (0...8).map { CODE_RANGE[rand(CODE_RANGE_SIZE)] }.join
  end

  def submit!
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

class Attempt < ApplicationRecord
  include AASM

  aasm do
    state :pending, initial: true
    state :answering
    state :submitted

    event :start, before_transaction: :mark_start do
      transitions from: [:pending], to: :answering
    end

    event :submit, before_transaction: :mark_submitted do
      transitions from: [:answering], to: :submitted
    end
  end

  belongs_to :quiz
  has_many :attempt_answers, dependent: :destroy
  accepts_nested_attributes_for :attempt_answers

  validates :name, presence: true
  validates_uniqueness_of :permalink

  # scope :by_default, -> {order("score desc, time_diff asc")}
  broadcasts_to ->(attempt) { "attempts_quiz_#{attempt.quiz_id}" } #, target: "attempt_list_real"

  def to_s
    self.name
  end

  def to_param
    self.permalink
  end

  before_create :generate_quiz_sheet
  def generate_quiz_sheet
    quiz = self.quiz

    questions = quiz.shuffle_questions ? quiz.questions.shuffle : quiz.questions.by_seq

    questions.each_with_index do |q, idx|
      aa = self.attempt_answers.build
      aa.question = q
      aa.seq = idx
    end
  end

  def mark_start
    self.start_at = Time.now
  end

  def mark_submitted
    self.end_at = Time.now
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

  def self.rank attempts
    attempts.sort_by{|att| [-att.calc_score[:score], att.time_diff.blank? ? 999999999 : att.time_diff ]}
  end


  before_save :record_time_diff
  def record_time_diff
    if self.end_at and self.start_at
      self.time_diff = self.end_at - self.start_at
    end
  end

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

    {correct_count: correct_count, score: s}
  end

  def formatted_score
    res = self.calc_score

    "#{res[:correct_count]} / #{self.quiz.questions.size}; score: #{res[:score]}"
  end

end

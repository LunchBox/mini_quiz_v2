class Question < ApplicationRecord
	belongs_to :quiz
	belongs_to :user

	has_many :question_options, dependent: :destroy
	has_many :attempt_answers, dependent: :destroy

	serialize :correct_options

	attr_accessor :batch_options

	validates :subject, presence: true

	# has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	# validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  scope :by_seq, -> { order "seq asc, id desc"}

  acts_as_list column: :seq, scope: :quiz

	def to_s
    self.subject
	end

	before_validation :batch_load_options
	def batch_load_options
		unless batch_options.blank?
			self.question_options.clear
			self.batch_options.each_line do |line|
				next if line.blank?
				qo = self.question_options.new
				qo.content = line
			end
		end
	end

  def no_answer?
    self.correct_options.blank?
  end

  def has_answer?
    !self.no_answer?
  end

  def single_answer?
    self.has_answer? and self.correct_options.size == 1
  end

  def correct? question_option
    self.correct_options.try :include?, question_option.id.to_s
  end

end

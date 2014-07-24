class Response < ActiveRecord::Base
  validates :respondent_id, :answer_id, :presence => true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poll_author

  belongs_to(
  :answer_choice,
  :class_name => "AnswerChoice",
  :foreign_key => :answer_id,
  :primary_key => :id
  )

  belongs_to(
  :respondent,
  :class_name => "User",
  :foreign_key => :respondent_id,
  :primary_key => :id
  )

  has_one(
  :question,
  :through => :answer_choice,
  :source => :question
  )

  def poll
    question.poll
  end

  def sibling_responses
    question.responses.
            where(respondent_id: self.respondent_id).
            where("responses.id != ? OR ? IS NULL", self.id, self.id)
  end

  private
  def respondent_has_not_already_answered_question
    sibling_responses.count == 0
  end
  def respondent_is_not_poll_author
    poll.author_id != self.respondent_id
  end

end


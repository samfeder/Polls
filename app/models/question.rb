class Question < ActiveRecord::Base
  validates :poll_id, :presence => true

  belongs_to(
  :poll,
  :class_name => "Poll",
  :foreign_key => :poll_id,
  :primary_key => :id
  )


  has_many(
  :answer_choices,
  :class_name => "AnswerChoice",
  :foreign_key => :question_id,
  :primary_key => :id
  )

  has_many(
  :responses,
  :through => :answer_choices,
  :source => :responses
  )

  has_many(
  :respondents,
  :through => :responses,
  :source => :respondent
  )

  def results
    a = answer_choices.
        select("answer_choices.text, COUNT(respondent_id) AS votes").
        joins("LEFT OUTER JOIN responses ON
              answer_choices.id = responses.answer_id").
        group("answer_choices.id")

    a.map do |response|
      { response.text => response.votes }
    end
  end


end
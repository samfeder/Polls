class User < ActiveRecord::Base
  validates :user_name, :presence => true, :uniqueness => true

  has_many(
  :authored_polls,
  :class_name => "Poll",
  :foreign_key => :author_id,
  :primary_key => :id
  )

  has_many(
  :responses,
  :class_name => "Response",
  :foreign_key => :respondent_id,
  :primary_key => :id
  )



  def completed_polls
    str = <<-SQL
    LEFT OUTER JOIN questions ON poll_id = polls.id
    LEFT OUTER JOIN answer_choices ON question_id = questions.id
    LEFT JOIN
    (SELECT * FROM responses WHERE respondent_id = #{self.id}) AS tbl
    ON answer_id = answer_choices.id
    SQL
    a = Poll.select("polls.*")
    .joins(str)
    .group("polls.id")
    .having('COUNT(DISTINCT questions.*) = COUNT(tbl.*)')


  end

end
require_relative 'questions_database.rb'

class Question_Follow

    attr_accessor :user_id, :question_id

    def self.find_by_id(id)
        follows = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                question_id = ?
        SQL
        return nil if follows.length == 0
        follows.map { |follow| Question_Follow.new(follow) }    
    end

    def initialize(question_follow_data)
        @user_id = question_follow_data['user_id']
        @question_id = question_follow_data['question_id']
    end

end
require_relative 'questions_database.rb'

class Question_Like

    def self.find_by_id(id)
        likes = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                question_id = ?
        SQL
        return nil if likes.length == 0
        likes.map { |like| Question_Like.new(like) }    
    end

    def initialize(user_data)
        @user_id = user_data['user_id']
        @question_id = user_data['question_id']
        @likes = user_data['likes']
    end

end

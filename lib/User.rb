require_relative 'questions_database.rb'

class User

    attr_accessor :id, :first_name, :last_name
    
    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        return nil if user.length == 0
        User.new(user.first)    
    end

    def self.find_by_name(first_name, last_name)
        user = QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name)
            SELECT
                *
            FROM
                users
            WHERE
                first_name = ? AND last_name = ?
        SQL
        return nil if user.length == 0
        User.new(user.first)
    end

    def initialize(user_data)
        @id = user_data['id']
        @first_name = user_data['first_name']
        @last_name = user_data['last_name']
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        Question_Follow.followed_questions_for_user_id(id)
    end

    def liked_questions
        Question_Like.liked_questions_for_user_id(id)
    end

    def average_karma
        return 0 if authored_questions == nil
        total_questions = authored_questions.length
        total_likes = authored_questions.reduce(0) { |sum, question| sum + question.num_likes }
        total_likes / total_questions
    end

end
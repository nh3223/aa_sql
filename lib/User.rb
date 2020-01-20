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

end
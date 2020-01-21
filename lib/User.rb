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

    def slow_average_karma
        # After reviewing solution, this is slow due to potential for many database calls
        # from the question.num_likes method
        return 0 if authored_questions == nil
        total_questions = authored_questions.length
        total_likes = authored_questions.reduce(0) { |sum, question| sum + question.num_likes }
        total_likes / total_questions
    end

    def average_karma
        total_questions = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                COUNT(title)
            FROM
                questions
            WHERE
                user_id = ?
        SQL
        questions = total_questions.first['COUNT(title)']
        return 0 if questions == 0
        total_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                SUM(likes)
            FROM
                question_likes
            JOIN
                questions on questions.id = question_likes.question_id   
            WHERE
                questions.user_id = ?
        SQL
        likes = total_likes.first['SUM(likes)'].to_f
        likes / questions
    end
    
    def save
        unless @id
            QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name)
                INSERT INTO
                    users(first_name, last_name)
                VALUES
                    (?, ?)
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
        else
            QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name, id)
                UPDATE
                    users
                SET
                    first_name = ?, last_name = ?
                WHERE
                    id = ?
            SQL
        end
    end

end

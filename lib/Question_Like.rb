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

    def self.likers_for_question_id(question_id)
        likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                users
            JOIN
                question_likes ON question_likes.user_id = users.id
            WHERE
                question_likes.question_id = ?
        SQL
        return nil if likers.length == 0
        likers.map { |liker| User.new(liker) }
    end

    def self.num_likes_for_question_id(question_id)
        num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                likes
            FROM
                question_likes
            WHERE
                question_id = ?
        SQL
        num_likes.first['likes']
    end

    def self.liked_questions_for_user_id(user_id)
        liked = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                questions
            JOIN
                question_likes ON question_likes.question_id = questions.id
            WHERE
                question_likes.user_id = ?
        SQL
        return nil if liked == 0
        liked.map { |question| Question.new(question) }
    end

    def self.most_liked_questions(n)
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                *
            FROM
                questions
            JOIN
                question_likes ON question_likes.question_id = questions.id
            GROUP BY
                question_likes.question_id
            ORDER BY
                COUNT(question_likes.question_id) DESC LIMIT ?
        SQL
        return nil if questions.length == 0
        questions.map { |question| Question.new(question) }
    end

    def initialize(user_data)
        @user_id = user_data['user_id']
        @question_id = user_data['question_id']
        @likes = user_data['likes']
    end

end

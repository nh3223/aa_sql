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

    def self.followers_for_question_id(question_id)
        followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                users
            JOIN    
                question_follows ON users.id = question_follows.user_id
            WHERE
                question_follows.question_id = ?
        SQL
        return nil if followers.length == 0
        followers.map { |follower| User.new(follower) }    
    end

    def self.followed_questions_for_user_id(user_id)
        followed_questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                questions
            JOIN    
                question_follows ON questions.id = question_follows.question_id
            WHERE
                question_follows.user_id = ?
        SQL
        return nil if followed_questions.length == 0
        followed_questions.map { |question| Question.new(question) }   
    end

    def self.most_followed_questions(n)
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                *
            FROM
                questions
            JOIN
                question_follows ON question_follows.question_id = questions.id
            GROUP BY
                question_follows.question_id
            ORDER BY
                COUNT(question_follows.question_id) DESC LIMIT ?
        SQL
        return nil if questions.length == 0
        questions.map { |question| Question.new(question) }
    end

    def initialize(question_follow_data)
        @user_id = question_follow_data['user_id']
        @question_id = question_follow_data['question_id']
    end

end
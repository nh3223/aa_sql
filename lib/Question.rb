require_relative 'questions_database.rb'

class Question

    attr_accessor :id, :title, :body, :user_id

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil if question.length == 0
        Question.new(question.first)    
    end

    def self.find_by_author_id(author_id)
        author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                user_id = ?
        SQL
        return nil if author.length == 0
        author.map { |question| Question.new(question) }
    end

    def initialize(question_data)
        @id = question_data['id']
        @title = question_data['title']
        @body = question_data['body']
        @user_id = question_data['user_id']
    end

    def author
        User.find_by_id(user_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        Question_Follow.followers_for_question_id(id)
    end

end
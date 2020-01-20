require_relative 'questions_database.rb'

class Reply

    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body
    
    def self.find_by_id(id)
        answer = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil if answer.length == 0
        Reply.new(answer.first)    
    end

    def self.find_by_user_id(user_id)
        answers = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        return nil if answers.length == 0
        answers.map { |answer| Reply.new(answer) }
    end

    def self.find_by_question_id(question_id)
        answers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil if answers.length == 0
        answers.map { |answer| Reply.new(answer) }
    end

    def initialize(reply_data)
        @id = reply_data['id']
        @question_id = reply_data['question_id']
        @parent_reply_id = reply_data['parent_reply_id']
        @user_id = reply_data['user_id']
        @body = reply_data['body']
    end

    def author
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end

    def child_replies
        children =  QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        return nil if children.length == 0
        children.map { |child| Reply.new(child) }
    end

end
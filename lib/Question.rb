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

    def initialize(question_data)
        @id = question_data['id']
        @title = question_data['title']
        @body = question_data['body']
        @user_id = question_data['user_id']
    end

end
require_relative 'questions_database.rb'

class Reply

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

    def initialize(reply_data)
        @id = reply_data['id']
        @question_id = reply_data['question_id']
        @parent_reply_id = reply_data['parent_reply_id']
        @user_id = reply_data['user_id']
        @body = reply_data['body']
    end

end
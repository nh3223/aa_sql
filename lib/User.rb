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

    def initialize(user_data)
        @id = user_data['id']
        @first_name = user_data['first_name']
        @last_name = user_data['last_name']
    end

end
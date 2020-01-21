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

    def self.most_followed(n)
        Question_Follow.most_followed_questions(n)
    end

    def self.most_liked(n)
        Question_Like.most_liked_questions(n)
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

    def likers
        Question_Like.likers_for_question_id(id)
    end

    def num_likes
        Question_Like.num_likes_for_question_id(id)
    end
    
    def save
        unless @id
            QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id)
                INSERT INTO
                    questions(title, body, user_id)
                VALUES
                    (?, ?, ?)
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
        else
            QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id, id)
                UPDATE
                    questions
                SET
                    title = ?, body = ?, user_id = ?
                WHERE
                    id = ?
            SQL
        end
    end

end
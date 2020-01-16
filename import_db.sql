PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
    id          INTEGER     PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL
);

CREATE TABLE questions (
    id      INTEGER         PRIMARY KEY,
    title   VARCHAR(50)     NOT NULL,
    body    TEXT            NOT NULL,
    user_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    user_id     INTEGER PRIMARY KEY,
    question_id INTEGER PRIMARY KEY,

    FOREIGN KEY (user_id)     REFERENCES  users(id),
    FOREIGN KEY (question_id) REFERENCES  questions(id)
);

CREATE TABLE replies (
    id              INTEGER PRIMARY KEY,
    question_id     INTEGER NOT NULL,
    parent_reply_id INTEGER,
    user_id         INTEGER NOT NULL,
    body            TEXT    NOT NULL,

    FOREIGN KEY (question_id) REFERENCES  questions(id),
    FOREIGN KEY (parent_id)   REFERENCES  replies(id)
);

CREATE TABLE question_likes (
    user_id     INTEGER PRIMARY KEY,
    question_id INTEGER PRIMARY KEY,
    likes       BOOLEAN NOT NULL,

    FOREIGN KEY (user_id)     REFERENCES  users(id),
    FOREIGN KEY (question_id) REFERENCES  questions(id)
);

INSERT INTO
    users(first_name, last_name)
VALUES
    ('Jean','Valjean'),
    ('Inspector','Javert'),
    ('John','Doe'),
    ('Jane','Roe');

INSERT INTO
    questions(title, body, user_id)
VALUES
    ('Les Miserables','Who am I?', (SELECT id FROM users WHERE last_name = 'Valjean')),
    ('Chicken','Why did the chicken cross the road?', (SELECT id FROM users WHERE last_name = 'Doe'));

INSERT INTO
    replies(question_id,parent_reply_id,user_id,body)
VALUES
    (1, NULL, (SELECT id FROM users WHERE last_name = 'Javert'), '24601'),
    (1, 1, (SELECT id FROM users WHERE last_name = 'Valjean'), "I'm Jean Valjean!"),
    (2, NULL, (SELECT id FROM users WHERE last_name = 'Roe'), 'To get to the other side.');

INSERT INTO
    question_likes(user_id, question_id, likes)
VALUES
    (3,1,1),
    (2,2,1);
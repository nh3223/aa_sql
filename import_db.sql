CREATE TABLE users (
    id          INTEGER PRIMARY KEY,
    first_name  TEXT    NOT NULL,
    last_name   TEXT    NOT NULL
);

CREATE TABLE questions (
    id      INTEGER PRIMARY KEY,
    title   TEXT    NOT NULL,
    body    TEXT    NOT NULL,
    user_id INTEGER,

    FOREIGN KEY user_id REFERENCES users(id)
);

CREATE TABLE question_follows (
    user_id     INTEGER PRIMARY KEY,
    question_id INTEGER PRIMARY KEY,

    FOREIGN KEY user_id     REFERENCES  users(id),
    FOREIGN KEY question_id REFERENCES  questions(id)
);

CREATE TABLE replies (
    id              INTEGER PRIMARY KEY,
    question_id     INTEGER NOT NULL,
    parent_reply_id INTEGER,
    user_id         INTEGER NOT NULL,
    body            TEXT,

    FOREIGN KEY question_id REFERENCES  questions(id),
    FOREIGN KEY parent_id   REFERENCES  replies(id),
    FOREIGN KEY user_id     REFERENCES  users(id)
);

CREATE TABLE question_likes (
    user_id     INTEGER PRIMARY KEY,
    question_id INTEGER PRIMARY KEY,
    likes       BOOLEAN NOT NULL,

    FOREIGN KEY user_id     REFERENCES  users(id),
    FOREIGN KEY question_id REFERENCES  questions(id)
);
USE trill;
DESCRIBE follows;

CREATE TABLE follows (
    created_at timestamp NOT NULL,
    updated_at timestamp NOT NULL, 
    deleted_at timestamp NOT NULL,
    followee varchar(128) NOT NULL,
    following varchar(128) NOT NULL,
    CONSTRAINT PK_follows PRIMARY KEY (followee, following),
    CONSTRAINT FK_followee FOREIGN KEY (followee)
    REFERENCES users(username),
    CONSTRAINT FK_following FOREIGN KEY (following)
    REFERENCES users(username)
);
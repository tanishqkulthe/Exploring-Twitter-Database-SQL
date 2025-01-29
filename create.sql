-- Create the Users table
CREATE TABLE Users (
    User_ID bigint PRIMARY KEY,
    User_Name character varying(255),
    User_screen_name character varying(255),
    User_location character varying(255),
    user_utc_offset int,
    user_time_zone character varying(127),
    user_followers_count int,
    user_friends_count int,
    user_lang character varying(10),
    user_description varchar(255),
    user_status_count varchar(255),
    user_created_at timestamp with time zone
);

-- Create the Tweets table
CREATE TABLE Tweets (
    Tweet_ID bigint PRIMARY KEY,
    User_ID bigint REFERENCES Users(User_ID),
    in_reply_to_user_id bigint,
    created_at timestamp with time zone,
    Text varchar(255),
    in_reply_to_screen_name character varying(255),
    in_reply_to_status_id bigint,
    retweet_count int,
    tweet_source varchar(255),
    retweet_of_tweet_id bigint
);


-- Create the Hashtags table
CREATE TABLE Hashtags (
    Hashtag_ID serial PRIMARY KEY,
    Hashtag varchar(144)
);

-- Create the Tweet_Hashtag table
CREATE TABLE tweet_hashtag (
    tweet_hashtag_id SERIAL PRIMARY KEY,
    tweet_id BIGINT,
    hashtag_id BIGINT,
    CONSTRAINT fk_tweet_id
        FOREIGN KEY (tweet_id)
        REFERENCES tweets (tweet_id),
    CONSTRAINT fk_hashtag_id
        FOREIGN KEY (hashtag_id)
        REFERENCES hashtags (hashtag_id)
); 
-- Created the foreign key with different syntax



-- Move data from bad_giant_table to Users table
INSERT INTO Users (User_ID, User_Name, User_screen_name, User_location, user_utc_offset, user_time_zone, user_followers_count, user_friends_count, user_lang, user_description, user_status_count, user_created_at)
SELECT DISTINCT user_id, user_name, user_screen_name, user_location, user_utc_offset, user_time_zone, user_followers_count, user_friends_count, user_lang, user_description, user_status_count, user_created_at
FROM bad_giant_table
ON CONFLICT DO NOTHING;

-- Move data from bad_giant_table to Tweets table
INSERT INTO Tweets (Tweet_ID, User_ID, in_reply_to_user_id, created_at, Text, in_reply_to_screen_name, in_reply_to_status_id, retweet_count, tweet_source, retweet_of_tweet_id)
SELECT DISTINCT tweet_id, user_id, in_reply_to_user_id, created_at, text, in_reply_to_screen_name, in_reply_to_status_id, retweet_count, tweet_source, retweet_of_tweet_id
FROM bad_giant_table
ON CONFLICT DO NOTHING;

-- Move data from bad_giant_table to Hashtags table
INSERT INTO Hashtags (Hashtag)
SELECT DISTINCT hashtag1 FROM bad_giant_table WHERE hashtag1 IS NOT NULL
UNION
SELECT DISTINCT hashtag2 FROM bad_giant_table WHERE hashtag2 IS NOT NULL
UNION
SELECT DISTINCT hashtag3 FROM bad_giant_table WHERE hashtag3 IS NOT NULL
UNION
SELECT DISTINCT hashtag4 FROM bad_giant_table WHERE hashtag4 IS NOT NULL
UNION
SELECT DISTINCT hashtag5 FROM bad_giant_table WHERE hashtag5 IS NOT NULL
UNION
SELECT DISTINCT hashtag6 FROM bad_giant_table WHERE hashtag6 IS NOT NULL
ON CONFLICT DO NOTHING;

-- Move data from bad_giant_table to tweet_hashtag table
INSERT INTO tweet_hashtag (tweet_id, hashtag_id)
SELECT tweet_id, hashtag_id FROM (
    SELECT tweet_id, 
           unnest(string_to_array(concat_ws(',', hashtag1, hashtag2, hashtag3, hashtag4, hashtag5, hashtag6), ',')) AS hashtag_name
    FROM bad_giant_table
) AS tweet_hashtag
JOIN hashtags ON tweet_hashtag.hashtag_name = hashtags.hashtag
ON CONFLICT DO NOTHING;

-- setting appropriate encoding to avoid encoding errors
SET client_encoding = 'UTF8';


-- Section 1
-- How many tweets are there in total?
SELECT COUNT(*) AS total_tweets FROM Tweets; 
-- Every row represents a unique tweet, so number of rows is number of tweets

-- How are these tweets distributed across languages? Write a query that shows, for every
-- language( user_lang ) the number of tweets in that language.
SELECT u.user_lang AS language, COUNT(*) AS num_tweets FROM Tweets t JOIN Users u ON t.User_ID = u.User_ID GROUP BY u.user_lang;
-- Performing join on tweets and users table using User_id, grouping by user language, the number of rows 
-- will be the number of tweets for that language

-- Compute, for each language, the fraction of total tweets that have that language setting, as well as
-- the fraction of the number of users that have that language setting.
SELECT u.user_lang, COUNT(*) AS num_tweets, COUNT(DISTINCT t.User_ID) AS num_users, COUNT(*)::float / (SELECT COUNT(*) FROM Tweets)::float AS tweet_fraction, COUNT(DISTINCT t.User_ID)::float / (SELECT COUNT(DISTINCT User_ID) FROM Users)::float AS user_fraction FROM Tweets t JOIN Users u ON t.User_ID = u.User_ID GROUP BY u.user_lang;
-- Joining tweets and users table with User_id, grouped by user_lang. Calculating fraction of all tweet
-- belonging to each language and fraction of all users posted tweet in each language

-- Section 2
-- What fraction of the tweets are retweets?
SELECT COUNT(*)::float / (SELECT COUNT(*) FROM Tweets)::float AS retweet_fraction FROM Tweets WHERE retweet_count > 0;
-- Dividing tweets that are retweeted with total number of tweets.

-- Compute the average number of retweets per tweet.
SELECT AVG(retweet_count) AS avg_retweets FROM Tweets;
-- Averaging retweet_count column to find average retweet count

-- What fraction of the tweets are never retweeted?
SELECT COUNT(*)::float / (SELECT COUNT(*) FROM Tweets)::float AS no_retweet_fraction FROM Tweets WHERE retweet_count = 0;
-- Dividing tweets that are never tweeted with total number of tweets

-- What fraction of the tweets are retweeted fewer times than the average number of retweets (and what
-- does this say about the distribution)?
WITH avg_retweets AS ( SELECT AVG(retweet_count) AS avg_retweets FROM Tweets )
SELECT COUNT(*)::float / (SELECT COUNT(*) FROM Tweets)::float AS retweeted_less_than_avg_fraction FROM Tweets WHERE retweet_count < (SELECT avg_retweets FROM avg_retweets);
-- Calculated the average number of retweets, then counted number of tweets that are less retweeted than
-- average, then divided the count with total number of tweets
-- The fraction is 0.94, that means the distribution is right skewed

-- Section 3
-- What is the number of distinct hashtags found in these tweets?
SELECT COUNT(DISTINCT Hashtag) AS num_distinct_hashtags FROM Hashtags;
-- Distinct word will not count the repeated hashtag

-- What are the top ten most popular hashtags, by number of usages?
SELECT Hashtags.Hashtag, COUNT(tweet_hashtag.tweet_id) AS usage_count FROM Hashtags INNER JOIN tweet_hashtag ON Hashtags.Hashtag_ID = tweet_hashtag.hashtag_id GROUP BY Hashtags.Hashtag ORDER BY usage_count DESC LIMIT 10;
-- Joined the table hashtags and tweet_hashtag on Hashtag_id, grouped by hashtag and ordered by the
-- usage count, printed in descending order


-- Write a query giving, for each language, the top three most popular hashtags in that language.
WITH hashtag_counts AS ( SELECT Users.user_lang, Hashtags.Hashtag, COUNT(tweet_hashtag.tweet_id) AS usage_count, ROW_NUMBER() OVER (PARTITION BY Users.user_lang ORDER BY COUNT(tweet_hashtag.tweet_id) DESC) AS rank FROM Users JOIN Tweets ON Users.User_ID = Tweets.User_ID JOIN tweet_hashtag ON Tweets.Tweet_ID = tweet_hashtag.tweet_id JOIN Hashtags ON tweet_hashtag.hashtag_id = Hashtags.Hashtag_ID GROUP BY Users.user_lang, Hashtags.Hashtag)
SELECT user_lang, Hashtag, usage_count FROM hashtag_counts WHERE rank <= 3 ORDER BY usage_count DESC;
-- Calculating the count of each hashtag usage for each user language, and rank of each hashtag count
-- within each language, then selecting language, hashtag, and usage_count for only the top three
-- hashtags in each language.

-- Section 4
-- How many tweets are neither replies, nor replied to?
SELECT COUNT(*) FROM Tweets WHERE in_reply_to_status_id IS NULL AND in_reply_to_user_id IS NULL;
-- Counting the tweets that are not a reply to another tweet, and also has not received any reply

-- If a user user1 replies to another user user2, what is the probability that they have the same
-- language setting?
SELECT COUNT(*) FILTER (WHERE Users1.user_lang = Users2.user_lang) AS same_lang_count, COUNT(*) AS total_count, COUNT(*) FILTER (WHERE Users1.user_lang = Users2.user_lang)::numeric / COUNT(*)::numeric AS probability FROM Tweets AS Replies INNER JOIN Users AS Users1 ON Replies.User_ID = Users1.User_ID INNER JOIN Users AS Users2 ON Replies.in_reply_to_user_id = Users2.User_ID WHERE Replies.in_reply_to_user_id IS NOT NULL AND Replies.in_reply_to_status_id IS NOT NULL;
-- Counting the number of replies where the language of the user who replied matches the language
-- of the user being replied to, and dividing that count by the total number of replies


-- How does this compare to the probability that two arbitrary users have the same language setting?

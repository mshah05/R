library('twitteR')
library('tm')
library('plyr')
library('wordcloud')

api_key <- 'your api key'
api_secret <- 'your api secret key'
access_token <- 'your access token'
access_token_secret <- 'your access token secret'

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
tweets <- searchTwitter('@cocacola', n=25)

tweets_txt <- ldply(tweets, statusText)
tweets_vect = tweets_txt$V1
tweets_corpus <- Corpus(VectorSource(tweets_vect))
tweets_corpus <- tm_map(tweets_corpus, tolower)
tweets_corpus <- tm_map(tweets_corpus, removePunctuation)
tweets_corpus <- tm_map(tweets_corpus, function(x) removeWords(x, stopwords()))

par(ask=TRUE)

wordcloud(tweets_corpus)


tweets_tdm <- TermDocumentMatrix(tweets_corpus)

findFreqTerms(tweets_tdm, lowfreq = 10)
findAssocs(tweets_tdm, 'cloud', .49)
tweets2_tdm <- removeSparseTerms(tweets_tdm, sparse=0.90)
tweets2_m <- as.matrix(tweets2_tdm)
tweets2_dist <- dist(tweets2_m, method='euclidean')
plot(hclust(tweets2_dist), main='@cocacola      Cluster')

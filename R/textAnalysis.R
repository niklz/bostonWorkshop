library(gutenbergr)
library(tidytext)


gutenberg_works(title == "The Wonderful Wizard of Oz")

# grab book
wizardOfOz <- gutenberg_download(55)
head(wizardOfOz)

# tidy book
tidyWizzard <- wizardOfOz %>% unnest_tokens(word, text)

# Exercise

gutenberg_works(title == "Treasure Island")
treasureIsland <- gutenberg_download(120)
tidyIsland <- treasureIsland %>% unnest_tokens(word, text)


# count words
tidyWizzard %>% count(word, sort = TRUE)

# remove stop words and count again
tidyWizzard <- tidyWizzard %>% anti_join(stop_words)
tidyWizzard %>% count(word, sort = TRUE)

# removing uninteresting stuff
chrctrs <- data.frame(word = c("dorothy",
                               "scarecrow",
                               "woodman",
                               "lion",
                               "tin"))

# exercise

tidyIsland %>% count(word, sort = TRUE)
tidyIsland <- tidyIsland %>% anti_join(stop_words)
tidyIsland %>% count(word, sort = TRUE)


# Ngram

tidyWizzardNgram <- wizardOfOz %>% unnest_tokens(word,
                                                 text,
                                                 token = "ngrams",
                                                 n = 2)

tidyWizzardNgram %>% count(word, sort = TRUE)

# exercise

tidyIslandNgram <- treasureIsland %>% unnest_tokens(word,
                                                    text,
                                                    token = "ngrams",
                                                    n = 3)
tidyIslandNgram %>% count(word, sort = TRUE)

# wordcloud
library(wordcloud)
library(tidyr)

cloudWizzard <- wizardOfOz %>%
                unnest_tokens(word, text) %>%
                anti_join(stop_words) %>%
                count(word, sort = TRUE)

wordcloud(cloudWizzard$word, cloudWizzard$n, max.words = 50, colors = "red")

compCloud <- wizardOfOz %>%
             unnest_tokens(word, text) %>%
             anti_join(stop_words) %>%
             inner_join(get_sentiments("bing")) %>%
             count(word, sentiment, sort = TRUE) %>%
             spread(sentiment, n, fill = 0) %>%
             data.frame()

rownames(compCloud) <- compCloud$word
select(compCloud, -word) %>%
  comparison.cloud(colors = c("darkred", "darkgreen"),
                   max.words = 100)

# exercise

compCloudTreas <- treasureIsland %>%
                  unnest_tokens(word, text) %>%
                  anti_join(stop_words) %>%
                  inner_join(get_sentiments("bing")) %>%
                  count(word, sentiment, sort = TRUE) %>%
                  spread(sentiment, n, fill = 0) %>%
                  data.frame()

rownames(compCloudTreas) <- compCloudTreas$word
select(compCloudTreas, -word) %>%
  comparison.cloud(colors = c("darkred", "darkgreen"),
                   max.words = 100)


library(igraph)
library(ggraph)

tidyWizzardNgram <- wizardOfOz %>% 
                    unnest_tokens(word,
                                  text,
                                  token = "ngrams",
                                  n = 2) %>%
                    count(word, sort = TRUE) %>%
                    separate(word, c("firstWord", "secondWord", sep = " ")) %>%
                    anti_join(stop_words, by = c("firstWord" = "word")) %>%
                    anti_join(stop_words, by = c("secondWord" = "word")) %>%
                    filter(firstWord == "woodman")

iGraphObject <- tidyWizzardNgram %>%
                graph_from_data_frame()

#plotting

ggraph(iGraphObject) +
geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
geom_node_point() +
geom_edge_link()

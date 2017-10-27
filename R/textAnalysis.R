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


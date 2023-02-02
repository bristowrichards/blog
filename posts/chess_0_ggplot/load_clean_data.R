library(readr)
library(dplyr)

# read data from download
# the .txt. file is .gitignored because the file is too big!
ratings <- read_fwf(
  'quarto-blog/posts/chess_0_ggplot/players_list_foa.txt',
  col_types = 'icccccccnnnnnnnnnnf',
  skip=1
)

# copy columns
# needed to do this to speed up column type, which required skipping line
# readr::read_fwf doesn't allow to specify first row as colnames
columns = c("ID Number", "Name", "Fed", "Sex", "Tit", "WTit", "OTit", 
            "FOA", "SRtng", "SGm", "SK", "RRtng", "RGm", "Rk", "BRtng", 
            "BGm", "BK", "Byear", "Flag")

# set column names
colnames(ratings) <- columns
rm(columns)

# subset to columns of interest
ratings <- ratings[,c(1:6,9,12,15,18)]

# clean
ratings <- ratings |>
  filter(
    SRtng > 0, # must have rating and rating must be above 0
    Byear > 1900 # must have valid birth year
  ) |>
  mutate(
    Bdecade = factor(sapply(Byear, function(x) x - x %% 10)),
    Age = 2023 - Byear
  )

# save
saveRDS(ratings, file = 'quarto-blog/posts/chess_0_ggplot/ratings.Rds')
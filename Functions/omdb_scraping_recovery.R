library(httr2)
library(dplyr)
library(purrr)

get_rating_by_id <- function(imdb_id) {
  # Skip if the ID is missing
  if (is.na(imdb_id) || imdb_id == "") return(NA_real_)
  
  api_key <- Sys.getenv("OMDB_API_KEY")
  
  # Search using 'i' for IMDb ID instead of 't' for Title
  req <- request("http://www.omdbapi.com/") |>
    req_url_query(apikey = api_key, i = imdb_id) |>
    req_perform() |>
    resp_body_json()
  
  if (req$Response == "True" && req$imdbRating != "N/A") {
    return(as.numeric(req$imdbRating))
  } else {
    return(NA_real_)
  }
}

get_imdb_id_from_tmdb <- function(tmdb_id) {
  if (is.na(tmdb_id)) return(NA_character_)
  
  api_key <- Sys.getenv("TMDB_API_KEY")
  
  # API call to the 'external_ids' endpoint
  url <- paste0("https://api.themoviedb.org/3/movie/", tmdb_id, "/external_ids?api_key=", api_key)
  
  req <- tryCatch({
    request(url) %>% req_perform() %>% resp_body_json()
  }, error = function(e) return(NULL))
  
  if (!is.null(req$imdb_id)) {
    return(req$imdb_id)
  } else {
    return(NA_character_)
  }
}

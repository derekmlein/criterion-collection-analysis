library(httr2)
library(dplyr)

get_tmdb_data <- function(title, year) {
  api_key <- Sys.getenv("TMDB_API_KEY")
  
  # Step 1: Search to find the unique TMDb ID
  search_req <- request("https://api.themoviedb.org/3/search/movie") |>
    req_url_query(api_key = api_key, query = title, year = year) |>
    req_perform() |>
    resp_body_json()
  
  # Check if a result was found
  if (length(search_req$results) > 0) {
    tmdb_id <- search_req$results[[1]]$id # Take the most relevant match
    
    # Step 2: Get full details using that ID
    movie_req <- request(paste0("https://api.themoviedb.org/3/movie/", tmdb_id)) |>
      req_url_query(api_key = api_key) |>
      req_perform() |>
      resp_body_json()
    
    # Extract data safely
    return(data.frame(
      tmdb_id      = tmdb_id,
      runtime_min  = as.numeric(movie_req$runtime),
      genre        = paste(sapply(movie_req$genres, function(g) g$name), collapse = ", "),
      country      = paste(sapply(movie_req$production_countries, function(c) c$name), collapse = ", "),
      language     = movie_req$original_language,
      popularity   = movie_req$popularity,
      vote_average = movie_req$vote_average,
      vote_count   = movie_req$vote_count,
      stringsAsFactors = FALSE
    ))
  } else {
    # Return NAs if search fails
    return(data.frame(
      tmdb_id = NA, runtime_min = NA, genre = NA, 
      country = NA, language = NA, popularity = NA, vote_average = NA
    ))
  }
}

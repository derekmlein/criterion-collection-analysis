library(httr2)

get_imdb_data_v2 <- function(title, year) {
  api_key <- Sys.getenv("OMDB_API_KEY")
  
  # 1. Build the Request
  req <- request("http://www.omdbapi.com/") |>
    req_url_query(t = title, y = year, apikey = api_key) |>
    req_throttle(rate = 2 / 1) |> 
    req_retry(max_tries = 3)
  
  # 2. Perform with Safety (tryCatch prevents a crash if connection drops)
  resp_data <- tryCatch({
    req |> req_perform() |> resp_body_json()
  }, error = function(e) {
    message(paste("Error fetching:", title))
    return(list(Response = "False"))
  })
  
  # 3. Parse the Results
  if (resp_data$Response == "True") {
    return(data.frame(
      imdb_rating = as.numeric(resp_data$imdbRating),
      metascore   = as.numeric(resp_data$Metascore),
      stringsAsFactors = FALSE
    ))
  } else {
    # Returns NAs so your rows still align perfectly
    return(data.frame(imdb_rating = NA, country = NA, language = NA))
  }
}

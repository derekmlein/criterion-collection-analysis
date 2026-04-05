# 1. Load Packages
  library(tidyverse)
  library(janitor)
  library(usethis)
  library(httr2)
  library(ISOcodes)

# 2. Load Dataset
  criterion_raw <- read_csv(
    "Data/Raw/complete_criterion_collection_letterboxd.csv")
  
# 3. Clean Dataset
  criterion_cleaned <- criterion_raw %>% 
    select(-"Position", -"URL") %>% 
  # 3a. Standardize Column Names and Remove Non-Standard Characters
    clean_names() %>% 
    rename(title = name) %>% 
    mutate(
      description = str_remove_all(description, "[•,#]|<i>|</i>"), 
      description = str_replace_all(description, "Spine Number:", "Spine"), 
      across(c(description, title), str_squish)) %>% 
  # 3b. Extract Director, Spine, and Boxset Info from Description Column   
    mutate(
      director = 
        str_extract(description, "(?<=Directors?:\\s).*?(?=\\sSpine)"),
      spine = 
        as.integer(str_extract(description, "(?<=Spine:?\\s)\\d+")),
      boxset = 
        str_extract(description, "(?<=Collection:\\s).*?$")) %>% 
    select(-"description") %>% 
  # 3c. Reconcile Null Strings in Boxset Column
    mutate(boxset = replace_na(boxset, "Standalone")) %>% 
  # 3d. Generate Unique Movie IDs
    mutate(movie_id = title %>% 
          str_to_lower() %>% 
          str_replace_all("[[:punct:]]", "") %>% 
          str_replace_all("\\s+", "-") %>% 
          paste(year, sep = "-")) %>% 
  # 3e. Convert Year to Integer and Move Spine Column to Front
    mutate(year = as.integer(year)) %>% 
    relocate("spine")
        
# 4. Data Scraping from OMDb
    # --- CONFIGURATION ---
    DAILY_LIMIT <- 950                # OMDb free tier limit is 1,000
    SAVE_FILE <- "Data/Processed/criterion_omdb_merged.csv"
      
    # --- STEP 1: LOAD & CROSS-CHECK ---
    if (file.exists(SAVE_FILE)) {
      done_already <- read_csv(SAVE_FILE, show_col_types = FALSE)
      
      to_process <- criterion_cleaned %>%
        anti_join(done_already, by = c("title", "year")) %>%
        head(DAILY_LIMIT)
    } else {
      to_process <- head(criterion_cleaned, DAILY_LIMIT)}
      
    # --- STEP 2: THE LOOP (with Daily Limits) ---
    if (nrow(to_process) == 0) {
      message("Success: All movies in your list have been processed!")
    } else {
      message(paste("Starting batch of", nrow(to_process), "movies..."))
        
      for (i in 1:nrow(to_process)) {
        message(paste0(
          "Processing (", i, "/", nrow(to_process), "): ", to_process$title[i]))
          
        api_results <- get_imdb_data_v2(to_process$title[i], to_process$year[i])
          
        final_row <- bind_cols(to_process[i, ], api_results)
        
        write_csv(
          final_row, SAVE_FILE, append = file.exists(SAVE_FILE), 
          col_names = !file.exists(SAVE_FILE))}
        
      message("Batch complete! Check 'criterion_enriched.csv' for your data.")
    }

# 5. Data Scraping from TMDb
    # --- 1. CONFIGURATION ---
    SAVE_FILE_02 <- "Data/Processed/criterion_tmdb_merged.csv"
    
    # --- 2. RESUME LOGIC ---
    if (file.exists(SAVE_FILE_02)) {
      done_already <- read_csv(SAVE_FILE_02, show_col_types = FALSE)
      to_process <- criterion_cleaned %>%
        anti_join(done_already, by = c("title", "year"))
    } else {
      to_process <- criterion_cleaned}
    
    # --- 3. THE LOOP (without Daily Limits) ---
    if (nrow(to_process) == 0) {
      message("Project complete! All films have been enriched with TMDb data.")
    } else {
      message(paste("Processing all", nrow(to_process), "remaining films..."))
      
      for (i in 1:nrow(to_process)) {
        message(paste0(
          "[", i, "/", nrow(to_process), "] Pulling: ", to_process$title[i]))
        
        api_results <- get_tmdb_data(to_process$title[i], to_process$year[i])
        
        final_row <- bind_cols(to_process[i, ], api_results)
        write_csv(final_row, SAVE_FILE_02, 
                  append = file.exists(SAVE_FILE_02), 
                  col_names = !file.exists(SAVE_FILE_02))
        
        # Politeness timer: 0.2s = 5 requests per second
        Sys.sleep(0.2) 
      }
      message("Success! Your full Criterion-TMDb database is ready.")}

# 6. Load Scraped Datasets
  omdb_raw <- read_csv("Data/Processed/criterion_omdb_merged.csv")
  tmdb_raw <- read_csv("Data/Processed/criterion_tmdb_merged.csv")
    
# 7. Clean Scraped TMDb Dataset
  # 7a. Create Language Lookup Table with Missing Values Added
    lang_lookup <- ISO_639_2 %>% 
      select(Id = Alpha_2, language_full = Name) %>% 
      filter(!is.na(Id)) %>% 
      add_row(
        Id = c("cn", "sh", "xx"), 
        language_full = c("Cantonese", "Serbo-Croatian", "None Spoken")) %>% 
      mutate(language_full = str_replace_all(
        language_full, "Chinese", "Mandarin"))
    
  # 7b. Create a Patch to Amend Silent Films' Listed Language
    tmdb_silent_patch <- tmdb_raw %>% 
      filter(
        year < 1930 | 
        title %in% c(
            "À propos de Nice", "People on Sunday", "Borderline", "Limite", 
            "City Lights", "A Story of Floating Weeds", "Modern Times")) %>% 
      mutate(language = "xx")
    
  # 7c. Create a Manual Patch with Missing Metadata
    tmdb_missing_patch <- tribble(
      ~title, ~year, ~tmdb_id, ~runtime_min, 
      ~genre, ~country, ~language,
      ~popularity, ~vote_average, ~vote_count,
      
      "The Underground Railroad", 2021, 80039, 585,
      "Drama, Science Fiction", "United States of America", "en",
      7.8445, 7.2, 145,
      
      "Mangrove", 2020, 90705, 127,
      "Drama", "United Kingdom", "en",
      8.2423, 7.4, 48,
      
      "Lovers Rock", 2020, 90705, 70,
      "Drama", "United Kingdom", "en",
      8.2423, 6.4, 42,
      
      "Red, White and Blue", 2020, 90705, 80,
      "Drama", "United Kingdom", "en",
      8.2423, 6.9, 29,
      
      "Alex Wheatle", 2020, 90705, 66,
      "Drama", "United Kingdom", "en",
      8.2423, 5.9, 28,
      
      "Education", 2020, 90705, 63,
      "Drama", "United Kingdom", "en",
      8.2423, 6.7, 26,
      
      "Eight Hours Don’t Make a Day", 1972, 39837, 500,
      "Comedy, Drama", "Germany", "de",
      2.1043, 7.6, 19,
      
      "World on a Wire", 1973, 86449, 204,
      "Drama, Science Fiction, Mystery", "Germany", "de",
      3.7541, 7.2, 73,
      
      "Tanner '88", 1988, 1804, 353,
      "Comedy", "United States of America", "en",
      5.0501, 6.6, 7,
      
      "Scenes from a Marriage", 1973, 65170, 283,
      "Drama", "Sweden", "sv",
      4.757, 8.067, 142,
      
      "Fishing with John", 1991, 61820, 149,
      "Comedy, Documentary", "United States of America", "en",
      2.1129, 7.647, 34,
      
      "The Men Who Tread on the Tiger's Tail", 1945, 36916, 59,
      "Drama, History, Thriller, Adventure", "Japan", "ja",
      2.6275, 6.7, 97)
    
  # 7d. Clean TMDb Dataset and Add Patches
    tmdb_cleaned <- tmdb_raw %>% 
    # Update Rows from Patches
      rows_update(tmdb_silent_patch, by = c("title", "year")) %>% 
      rows_update(tmdb_missing_patch, by = c("title", "year")) %>% 
    # Convert Spine, Year, ID, Runtime, Vote Count, and Metascore to Int
      mutate(
        spine = as.integer(spine),
        year = as.integer(year),
        tmdb_id = as.integer(tmdb_id),
        runtime_min = as.integer(runtime_min), 
        vote_count = as.integer(vote_count)) %>% 
    # Join Language Lookup Table
      left_join(lang_lookup, by = c("language" = "Id")) %>% 
    # Rename and Clean Column Names
      select(-language) %>% 
      rename(
        tmdb_vote_count = vote_count,
        tmdb_vote_avg = vote_average,
        tmdb_popularity = popularity,
        language = language_full) %>% 
      relocate(language, .after = "country")
    
# 8. Clean Scraped OMDb Dataset
  # 8a. Create Patch for Titles with Missing IMDb ID
    omdb_id_patch <- tribble(
      ~title, ~year, ~imdb_id,
      
      "The Choice", 1987, "tt0092258",
      
      "Mangrove", 2020, "tt10551100",
      
      "Lovers Rock", 2020, "tt10551102",
      
      "Red, White and Blue", 2020, "tt10551108",
      
      "Alex Wheatle", 2020, "tt10551104",
      
      "Education", 2020, "tt10551106")
  
  # 8b. Convert TMDb ID to IMDb ID for Titles with Missing IMDb Score    
    omdb_with_ids <- omdb_raw %>%
      left_join(tmdb_cleaned %>% select(title, year, tmdb_id), by = c("title", "year")) %>%
      mutate(imdb_id = case_when(
        is.na(imdb_rating) & !is.na(tmdb_id) ~ map_chr(tmdb_id, get_imdb_id_from_tmdb),
        TRUE ~ NA_character_
      )) %>%
      rows_update(omdb_id_patch, by = c("title", "year"))
    
  # 8c. Scrape Missing IMDb Scores and Clean Final OMDb 
    omdb_cleaned <- omdb_with_ids %>% 
    # Scrape for Missing IMDb Scores using IMDb ID
      mutate(imdb_rating = case_when(
        is.na(imdb_rating) & !is.na(imdb_id) ~ map_dbl(imdb_id, get_rating_by_id),
        TRUE ~ imdb_rating
      )) %>%
    # Manual Adjustments
      mutate(imdb_rating = case_when(
        title == "Seoul 1988" ~ 5.9,
        title == "Adventures on the New Frontier" ~ 6.5,
        title == "The Vanishing Lion" ~ 6.5,
        TRUE ~ imdb_rating)) %>% 
    # Final Cleaning
      select(-tmdb_id, -imdb_id) %>% 
      mutate(across(c(spine, year, metascore), as.integer))
    
# 9. Merge OMDb and TMDb Datasets with our Master Criterion Dataset
  criterion_final <- omdb_cleaned %>% 
    select("movie_id", "imdb_rating", "metascore") %>% 
    right_join(tmdb_cleaned, by = c("movie_id")) %>% 
    mutate(director = str_replace_all(director, " &", ",")) %>% 
    relocate(imdb_rating, metascore, tmdb_id, movie_id, .after = last_col())
    
# 10. Export Final Datasets
  write_csv(criterion_final, "Outputs/criterion_final.csv")
  
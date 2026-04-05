# 1. Load Packages
  library(tidyverse)
  library(janitor)
  library(usethis)
  library(httr2)
  library(ISOcodes)
  
# 2. Create Datasets for Tableau
  criterion_tableau_master <- criterion_final %>% 
    select(-director, -genre, -country)
  
  criterion_tableau_genre <- criterion_final %>% 
    select(movie_id, genre) %>% 
    separate_rows(genre, sep = ",\\s*")
  
  criterion_tableau_director <- criterion_final %>% 
    select(movie_id, director) %>% 
    separate_rows(director, sep = ",\\s*")
  
  criterion_tableau_country <- criterion_final %>% 
    select(movie_id, country) %>% 
    separate_rows(country, sep = ",\\s*")
  
# 3. Export Datasets for Tableau
  write_csv(
    criterion_tableau_master, "Outputs/criterion_tableau_master.csv")
  write_csv(
    criterion_tableau_genre, "Outputs/criterion_tableau_genre.csv")
  write_csv(
    criterion_tableau_director, "Outputs/criterion_tableau_director.csv")
  write_csv(
    criterion_tableau_country, "Outputs/criterion_tableau_country.csv")
  
# 4. Create Tooltip Tibbles
  criterion_tooltip_title <- tribble(
    ~"recommended_title", ~"title_tooltip", ~"url",
    
    "Mother (2009)", 
    "Critically lauded, gripping neo-noir; a fan-favorite title from Bong that would benefit from a 4K UHD boutique release.",
    "https://letterboxd.com/film/mother-2009/",
    
    "The Host (2006)", 
    "Modern classic creature feature, and Bong's international breakout hit, in need of a 4K UHD restoration and release.",
    "https://letterboxd.com/film/the-host/",
    
    "Snowpiercer (2013)",
    "Bong's American debut, a star-studded sci-fi action parable; 4k UHD release is currently OOP.",
    "https://letterboxd.com/film/snowpiercer/",
    
    "Witness for the Prosecution (1957)",
    "Beloved, twist-filled Agatha Christie courtroom mystery in need of a 4K UHD restoration and release.",
    "https://letterboxd.com/film/witness-for-the-prosecution-1957/",
    
    "The Lost Weekend (1945)", 
    "Hard-hitting addiction drama and Best Picture Winner in need of a 4K UHD restoration and release.",
    "https://letterboxd.com/film/the-lost-weekend/",
    
    "The Seven Year Itch (1955)",
    "Classic Marilyn Monroe rom-com; featuring her most iconic scene and look; shot in Cinemascope and in need for a 4K UHD upgrade.",
    "https://letterboxd.com/film/the-seven-year-itch/",
    
    "Dr. Mabuse Trilogy (1922-1960)", 
    "Strategic boxset opportunity; pairs a currently OOP major silent classic with its lauded sequel already present in the Collection.",
    "https://letterboxd.com/film/dr-mabuse-the-gambler/",
    
    "The Woman in the Window (1944)", 
    "Classic Edward G. Robinson starring noir currently OOP in need of a 4K UHD restoration and release.",
    "https://letterboxd.com/film/the-woman-in-the-window/",
    
    "Fury (1936)",
    "Lang's American debut, a Spencer Tracy starring socio-political noir that's still timely and relevant today, yet currently OOP.",
    "https://letterboxd.com/film/fury/",
    
    "Incendies (2010)", 
    "Villeneuve's breakout film, a powerful, disturbing fusion of the war and mystery genres, and would benefit from a 4K UHD release.",
    "https://letterboxd.com/film/incendies/",
    
    "Das Boot (1981)", 
    "Claustrophobic submarine thriller mini-series that was internationally cut to feature length; the full-length masterpeice remains unavailable.",
    "https://letterboxd.com/film/das-boot/",
    
    "Underground (1995)",
    "Much lauded cult classic wartime satire that has a recent Blu-ray release already OOP.",
    "https://letterboxd.com/film/underground-1995/",
    
    "To Live (1994)", 
    "Deacdes-spanning epic from auteur Zhang Yimou; notoriously hard to track down in the US despite heavy audience demand.",
    "https://letterboxd.com/film/to-live/",
    
    "Judgment at Nuremberg (1961)", 
    "Sobering courtroom drama with a star-studded ensemble including Burt Lancaster and Judy Garland; currently OOP.",
    "https://letterboxd.com/film/judgment-at-nuremberg/",
    
    "Quo Vadis Aida? (2020)",
    "Devasting historical drama on the Srebrenica massacre; one of the decades's most acclaimed films, yet unavailable on home media in any format.",
    "https://letterboxd.com/film/quo-vadis-aida/",
    
    "Memento (2000)", 
    "Modern classic, mind-bending neo-noir from Christopher Nolan, one of his few titles not currently available in 4K UHD.",
    "https://letterboxd.com/film/memento/",
    
    "Cache (2005)", 
    "Much discussed and analyzed mystery from modern master Haneke; has never been available on home media in HD.",
    "https://letterboxd.com/film/cache/",
    
    "Laura (1944)", 
    "Classic mystery from Otto Preminger; long OOP with high demand on the secondary market, indicating a a prime candidate for a 4K restoration.",
    "https://letterboxd.com/film/laura/"
  )
  
# 5. Create Recommendation Dataset
  criterion_tableau_recs <- director_recommendations %>% 
    clean_names() %>% 
    rename(target = director) %>% 
    bind_rows(genre_recommendations %>% 
                clean_names() %>% 
                rename(target = genre)) %>% 
    separate_rows(recommended_titles, sep = ",\\s*") %>% 
    rename(recommended_title = recommended_titles) %>% 
    left_join(criterion_tooltip_title, by=c("recommended_title"))

# 6. Export Recommendation Dataset for Tableau
  write_csv(criterion_tableau_recs, "Outputs/criterion_tableau_recs.csv")
  
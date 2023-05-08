# EIA data download ----
library(httr)
library(jsonlite)

#https://towardsdatascience.com/use-r-to-pull-energy-data-from-the-department-of-energys-eia-api-8c4512946a28

key <- Sys.getenv("EIA_TOKEN")

# full data pull ----
gen_url <- "https://api.eia.gov/v2/electricity/operating-generator-capacity/data/?frequency=monthly&data[0]=county&data[1]=latitude&data[2]=longitude&data[3]=nameplate-capacity-mw&data[4]=net-summer-capacity-mw&data[5]=net-winter-capacity-mw&data[6]=operating-year-month&data[7]=planned-derate-summer-cap-mw&data[8]=planned-derate-year-month&data[9]=planned-retirement-year-month&data[10]=planned-uprate-summer-cap-mw&data[11]=planned-uprate-year-month&start=2023-02&sort[0][column]=entityid&sort[0][direction]=desc"
gen_key_url <- paste(paste(gen_url, "&api_key=", sep=""), key, sep = "")

test_gen_res <- GET(gen_key_url)

all_gen_data <- list()
offset <- 0
len <- 5000
max_row <- fromJSON(rawToChar(test_gen_res$content))$response$total 

i <- 1

while(offset < max_row){
  print(offset)
  page_url <- paste0(gen_key_url, "&offset=", as.character(offset), sep="")
  gen_res <- GET(page_url)
  gen_json_data <- fromJSON(rawToChar(gen_res$content))
  api_code <- gen_res$status_code
  print(api_code)
  if(api_code == "200"){
  gen_data <- data.frame(gen_json_data$response$data)
  all_gen_data[[i]] <- gen_data
  }
  print(i)
  offset <- offset + len
  i <- i + 1
  
}

gen_data_tbl <- do.call(rbind, all_gen_data)
gen_data_tbl %>% glimpse()
write_rds(gen_data_tbl, "C:/Users/rlrog/git_repos/power-analysis/data/gen_tbl_2023.rds")



#  Electricity generation ----
elec_url = "https://api.eia.gov/v2/electricity/facility-fuel/data/?frequency=monthly&data[0]=consumption-for-eg-btu&data[1]=generation&data[2]=gross-generation&start=2022-01&end=2022-12&sort[0][column]=plantCode&sort[0][direction]=desc"

elec_key_url <- paste(paste(elec_url, "&api_key=", sep=""), key, sep = "")

test_elec_res <- GET(elec_key_url)

all_elec_data <- list()
offset <- 0
len <- 5000
max_row <- fromJSON(rawToChar(test_elec_res$content))$response$total 

i <- 1
while(offset < max_row){
  print(offset)
  page_url <- paste0(elec_key_url, "&offset=", as.character(offset), sep="")
  elec_res <- GET(page_url)
  elec_json_data <- fromJSON(rawToChar(elec_res$content))
  api_code <- elec_res$status_code
  print(api_code)
  if(api_code == "200"){
    elec_data <- data.frame(elec_json_data$response$data)
    all_elec_data[[i]] <- elec_data
  }
  print(i)
  offset <- offset + len
  i <- i + 1
  
}

elec_data_tbl <- do.call(rbind, all_elec_data)
elec_data_tbl %>% glimpse()
write_rds(elec_data_tbl, "C:/Users/rlrog/git_repos/power-analysis/data/elec_tbl_2022.rds")



#  Write output ----
#write_rds(elec_data, "C:/Users/rlrog/git_repos/power-analysis/data/elec_tbl.rds")
#write_rds(gen_data, "C:/Users/rlrog/git_repos/power-analysis/data/gen_tbl.rds")


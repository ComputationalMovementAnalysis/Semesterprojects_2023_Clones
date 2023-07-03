#| message: false

library(tidyverse)
library(rvest)
library(kableExtra)






htmls <- list.files("data/PTED ENR FS23-Github URL (for Project Proposal and Project Files)-862011/","*.html",recursive = TRUE, full.names = TRUE)
htmls2 <- list.files("data/PTED ENR FS23-Github-Pages URL (of the rendered report)-892939/","*.html",recursive = TRUE, full.names = TRUE)


df_1 <- tibble(
  html_path = htmls, type = "code"
)
df_2 <- tibble(
  html_path = htmls2, type = "report"
)

df <- rbind(df_1,df_2) %>% 
  mutate(
    gruppe = str_extract(html_path, "Gruppe \\d{1,2}"),
    url = map_chr(html_path, \(x) html_text(read_html(x))) 
  ) %>% 
  distinct(gruppe, url, type) %>% 
  pivot_wider(names_from = type, values_from = url)


df$report[df$gruppe == "Gruppe 10"] <- "https://sophiawentkowski.github.io/Semester_project/PaT23_Semester_Project_Group10.html"
df$report[df$gruppe == "Gruppe 14"]  <- "https://cyrilgeistlich.github.io/cma-project/index.html"





# df$code[df$gruppe == "Gruppe 8"] <- "https://github.com/AntoniaHehli/Semesterproject"
# df$code[df$gruppe == "Gruppe 13"] <- "https://github.com/bieriluk/cma_semester_project"



df1 <- df %>% 
  mutate(
    gruppe_int = parse_number(gruppe),
    gruppe = paste("gruppe", str_pad(gruppe_int, 2, pad = "0"), sep = "_")
  ) %>% 
  arrange(gruppe_int) %>% 
  extract(report, c("username","repo"),"https:\\/\\/([\\w,-]+).github.io\\/([\\w,-]+)\\/",remove = FALSE) %>% 
  mutate(code2 = glue::glue("https://github.com/{username}/{repo}")) %>% 
  mutate(across(starts_with("code"),str_to_lower))

# THE ORIGINAL URL SOMETIMES CHANGES. THE CORRECT URL CAN BE INFERRED FROM THE REPORT URL
# df1 %>% 
#   filter(!startsWith(code,code2)) %>% 
#   select(code, code2, gruppe)


write_csv(df1, "df.csv", col_names = FALSE)
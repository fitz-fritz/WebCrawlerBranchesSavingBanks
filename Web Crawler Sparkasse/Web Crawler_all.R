install.packages("rvest")
install.packages("magicfor")


library(rvest)
library(magicfor)
library(tidyverse)

#######

###loop für alle bundesländer

url_gesamt <- "https://www.sparkasse.de/standorte/filialen"

#identify css selector
paragraphs <- read_html(url_gesamt) %>% html_nodes(".css-y95y2s") %>% html_text()

#umlaute umwandeln für websites
paragraphs_gesamt  <-stringi::stri_trans_general(paragraphs, "de-ASCII; Latin-ASCII") %>% tolower()

print(paragraphs_gesamt)

#url für alle Bundesländer

url_land <- paste0("https://www.sparkasse.de/standorte/filialen/",paragraphs_gesamt)

#loop url um alle Städte je Bundesland zu erhalten
magic_for(print, silent = TRUE)

for (n in 1:length(paragraphs_gesamt)) {
  paragraphs_land <- read_html(url_land[n]) %>% html_nodes(".css-y95y2s") %>% html_text()
  paragraphs_land  <-stringi::stri_trans_general(paragraphs_land, "de-ASCII; Latin-ASCII") %>% tolower()
  print(paragraphs_land)
}

list_land_paragrahps <- magic_result()


### perfect nested loop - all automatic
magic_for(print, silent = TRUE)

for (n in 1:length(paragraphs_gesamt)) {

stadt <- unlist(list_land_paragrahps[["paragraphs_land"]][[n]])
stadt <- chartr(" ", "-", stadt)
stadt <- gsub("[.]","", stadt)

paragraphs_stadt <- paragraphs_gesamt[n]

for (i in 1:length(stadt)) {
stadt_stadt <- stadt[i]

url_stadt <- paste0("https://www.sparkasse.de/standorte/filialen/",paragraphs_stadt,"/",stadt_stadt)

print(url_stadt)

Adresse <- read_html(url_stadt) %>% html_nodes(".css-ux108t") %>% html_text()
Filiale <- read_html(url_stadt) %>% html_nodes(".css-q1svxw") %>% html_text()

data <- cbind(Adresse, Filiale)

print(data)

}}

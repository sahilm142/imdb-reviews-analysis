library("rvest")
library("tm")
library("igraph")

base_url <- "https://www.imdb.com"

#### Collecting links for top 250 movies ####

url_top250 <- "https://www.imdb.com/chart/top?ref_=nv_mv_250"

#url_top250 <- "https://www.imdb.com/chart/toptv/?ref_=nv_tvv_250"

links_top250 <- c()
title_top250 <- c()
r <- read_html(url_top250)
nodes <- html_nodes(r, '.titleColumn a') 
title <- html_text(nodes)
links <- substr(html_attr(nodes, "href"),1,17)
reviews_url <- paste(base_url, links, "reviews", sep="")

#### Write CSV  ####
x <- data.frame(title,links)
write.csv(x,"imdb_title_linksmovies250.csv",row.names = F, col.names = c("Title", "Links"))

rating_review <- "?sort=helpfulnessScore&dir=desc&ratingFilter="
neg_review <- c(1,2,3,4,7,8,9,10)
pos_review <- c(7,8,9,10)


#### Extract Reviews with Summary for all ratings  ####
for(j in 1:250){
  #dir.create(file.path(j, 'summary'), recursive = TRUE)
  dir.create(file.path(j), recursive = TRUE)
  #j=11
  for(i in neg_review){
    ith_rating <- paste(reviews_url[j], rating_review, i, sep = "")
    
    read_ith_rating <- read_html(ith_rating)
    nodes_ith_rating <- html_nodes(read_ith_rating, '.lister-item-content')
    # Review Text
    rating <- html_text(nodes_ith_rating)
    rating_val <- substr(rating[1], 32, 33)
    if (rating_val!="10"){
      rating_val <- substr(rating[1], 32, 32)
    }
    if(i!=rating_val){
      print(rating_val)
      next
    }
      
    #rating <- html_nodes(read_ith_rating, '.ipl-rating')
    
    text_ith_rating <- html_text(html_nodes(read_ith_rating, '.show-more__control'))
    
    #text_ith_rating <- html_text(nodes_ith_rating)
    
    #summary_ith_rating <- html_text(html_nodes(read_ith_rating, '.title'))
    
    #x<-data.frame(j,i,text_ith_rating,summary_ith_rating)
    
    #file_name_summ <- paste(j,"/summary/",i,".txt",sep = "")
    file_name_rev <- paste(j,"/",i,".txt",sep = "")
    #writeLines(summary_ith_rating,file_name_summ)
    
    writeLines(text_ith_rating,file_name_rev)
    
    #x <- data.frame(summary_ith_rating, text_ith_rating)
    #write.csv(x,file_name,row.names = F, col.names = c("Summary", "Review"))
  }
}



reviews_html <- read_html(reviews_url)
reviews_nodes <- html_nodes(reviews_html, '.lister-item-content')
reviews_text <- html_text(reviews_nodes)

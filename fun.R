
library(RColorBrewer)

library(RCurl)
library(XML)


url <-  "http://www.met.reading.ac.uk/~extws/cgi-bin/storms/plots/"

getXWSEventNames <- function(url){
  
  doc = htmlParse(getURL(url), asText=TRUE)
  plain.text <- xpathSApply(doc, "//p", xmlValue)
  els = getNodeSet(doc, "/html//a[@href]")
  
  dirs <- sapply(els, function(el) xmlGetAttr(el, "href"))
  events <- dirs[6:length(dirs)]
  gsub("/",events, replacement = "")
  
}


en <- getXWSEventNames(url)


#
# get event footprints
#



url.repo <- "http://www.europeanwindstorms.org/repository/"

getFootPrint <- function(url,EventName, ColNames, origvalcol){
  
  file.event <- paste(EventName,"/",EventName,"_rawFootUncon.csv",sep="")
  url.event <- paste(url, file.event, sep = "" )
  fp <- read.csv(file = url.event, header = T, col.names = ColNames)
  
  # convert missing to 0 vale
  
  val.field <- origvalcol
  fp[,val.field] <- as.character(fp[,val.field])
  i <- fp[,val.field] == "**********"
  fp[i,val.field] <- 0
  fp[,val.field] <- as.numeric(fp[,val.field])
  fp
}



fp <- getFootPrint(url.repo, en[1], c("gid","ws"), "ws")

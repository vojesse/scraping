library(rjson)

#JSON of all games into data frame.
url = "http://stats.nba.com/stats/leaguegamelog?Counter=1000&Direction=DESC&LeagueID=00&PlayerOrTeam=T&Season=2014-15&SeasonType=Regular+Season&Sorter=PTS"
data = fromJSON(file = url)

#Create vector equal to the size of the JSON data for gameIDs and game names then populate.
gameIDVector = vector("list", length(data$resultSets[[1]]$rowSet))
gameNameVector = vector("list", length(data$resultSets[[1]]$rowSet))
for(i in 1:length(data$resultSets[[1]]$rowSet))
{
	gameIDVector[[i]] = data$resultSets[[1]]$rowSet[[i]][[5]]
	gameNameVector[[i]] = data$resultSets[[1]]$rowSet[[i]][[7]]
}

gameNameID = data.frame(unlist(gameNameVector), unlist(gameIDVector))
colnames(gameNameID) = c('gameName', 'gameID')
gameNameID <- gameNameID[!grepl('@', gameNameID$gameName),]
#Create pbp url's
gameNameID$gameURL = paste("http://stats.nba.com/stats/playbyplayv2?EndPeriod=10&EndRange=55800&GameID=", gameNameID$gameID, "&RangeType=2&Season=2014-15&SeasonType=Regular+Season&StartPeriod=1&StartRange=0", sep = "")
gameNameID$gameName = gsub(" ", "", gameNameID$gameName)
#All games in HOMvsAWY format
gameNameID$gameName = gsub(" ", "", gameNameID$gameName)
gameNameID$gameName = gsub("vs.", "vs", gameNameID$gameName)
gameNameID$gameName = paste(gameNameID$gameName, gameNameID$gameID, sep = '')

setwd('/Users/jessevo/Documents/NBA/net+/scrapes/pbps')
for (i in 1:length(gameNameID$gameName))
#For each game played.
{
	print(i)
	#Build filename from gameName and file extension
	fileName = paste(gameNameID$gameName[[i]], '.JSON', sep ='')
	url = gameNameID$gameURL[[i]]
	gID = gameNameID$gameID[[i]]
	json_data = fromJSON(file=url)
	json_data = toJSON(json_data)
	write(json_data, file = fileName)
}
Sys.time()

gameNameID$gameURL = paste("http://stats.nba.com/stats/boxscoretraditionalv2?EndPeriod=10&EndRange=28800&GameID=", gameNameID$gameID, "&RangeType=0&Season=2014-15&SeasonType=Regular+Season&StartPeriod=1&StartRange=0", sep = "")
setwd('/Users/jessevo/Documents/NBA/net+/scrapes/boxscores/traditional')
for (i in 1:length(gameNameID$gameName))
#For each game played.
{
	print(i)
	#Build filename from gameName and file extension
	fileName = paste(gameNameID$gameName[[i]], '.JSON', sep ='')
	url = gameNameID$gameURL[[i]]
	gID = gameNameID$gameID[[i]]
	json_data = fromJSON(file=url)
	json_data = toJSON(json_data)
	write(json_data, file = fileName)
}
Sys.time()

setwd('/Users/jessevo/Documents/NBA/net+/Scraping')
gameNameID$gameURL = paste("http://stats.nba.com/stats/boxscoreadvancedv2?EndPeriod=10&EndRange=34800&GameID=", gameNameID$gameID, "&RangeType=0&Season=2014-15&SeasonType=Regular+Season&StartPeriod=1&StartRange=0", sep = "")
setwd('/Users/jessevo/Documents/NBA/net+/scrapes/boxscores/advanced')
for (i in 1:length(gameNameID$gameName))
#For each game played.
{
	print(i)
	#Build filename from gameName and file extension
	fileName = paste(gameNameID$gameName[[i]], '.JSON', sep ='')
	url = gameNameID$gameURL[[i]]
	gID = gameNameID$gameID[[i]]
	json_data = fromJSON(file=url)
	json_data = toJSON(json_data)
	write(json_data, file = fileName)
}
Sys.time()

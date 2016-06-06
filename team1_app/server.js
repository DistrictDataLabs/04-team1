var express = require('express');
var app     = express();

app.set("port", process.env.PORT || 3000);

app.use(express.static("public"));
app.use(express.static("node_modules"));

app.get("/", function(request, response) 
{
	response.sendFile(__dirname + "/views/index.html");
});

app.get("/about", function(request, response) 
{
	response.sendFile(__dirname + "/views/about.html");
});

app.get("/project", function(request, response) 
{
	response.sendFile(__dirname + "/views/project.html");
});

app.get("/freqWords", function(request, response) 
{
	response.sendFile(__dirname + "/views/frequent_words.html");
});

app.get("/baleenFeeds", function(request, response) 
{
	response.sendFile(__dirname + "/views/baleen_feeds.html");
});

app.get("/sentiment", function(request, response) 
{
	response.sendFile(__dirname + "/views/sentiment/sentiment.html");
});

app.get("/Clinton", function(request, response) 
{
	response.sendFile(__dirname + "/views/sentiment/Clinton.html");
});

app.get("/Cruz", function(request, response) 
{
	response.sendFile(__dirname + "/views/sentiment/Cruz.html");
});

app.get("/Sanders", function(request, response) 
{
	response.sendFile(__dirname + "/views/sentiment/Sanders.html");
});

app.get("/Trump", function(request, response) 
{
	response.sendFile(__dirname + "/views/sentiment/Trump.html");
});

app.get("/locationMap", function(request, response) 
{
	response.sendFile(__dirname + "/views/locationMap/locations.html");
});

app.get("/d3sentiment", function(request, response) 
{
	response.sendFile(__dirname + "/views/D3_sentiment/d3_sentiment.html");
});

// START THE SERVER
// ==============================================
app.listen(app.get("port"), function() {
	console.log("server is running...");
});
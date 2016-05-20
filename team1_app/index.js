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


// START THE SERVER
// ==============================================
app.listen(app.get("port"), function() {
	console.log("server is running...");
});
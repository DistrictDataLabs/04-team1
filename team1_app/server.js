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

// START THE SERVER
// ==============================================
app.listen(app.get("port"), function() {
	console.log("server is running...");
});
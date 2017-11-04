var express = require("express");
var tasks = require("./routes/servicios");
var port = 8080 ;
var app  = express() ; 




app.use('/api', tasks);
app.listen(port, function()
{
console.log('Server started on port'+port);
});


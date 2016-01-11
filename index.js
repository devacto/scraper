var express = require('express');
var app = express();

// Reqs
// app/food should return all food in the database


app.get('/food', function(req, res) {
    res.send('Hello world');
});

var server = app.listen(3000, function() {
   console.log('Server running at http://localhost:' + server.address.port);
});

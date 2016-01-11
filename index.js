var express = require('express');
var app = express();

var Food = require('./db').Food;

app.get('/food', function (req, res) {
    Food.find({}, function(err, foods) {
        res.send(foods);
    })
});

app.get('/', function(req, res) {
    res.send('Welcome to the food database!');
});

var server = app.listen(3000, function() {
   console.log('Server running at http://localhost:' + server.address.port);
});

var uri = 'mongodb://localhost:27017/test';

var mongoose = require('mongoose');
mongoose.connect(uri);

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function (callback) {
    console.log('db connected');
});

var nutritionSchema = new mongoose.Schema({
    name: 'string',
    amount: 'string'
});

var foodSchema = new mongoose.Schema({
    food_name: 'string',
    food_company: 'string',
    nutritions: [nutritionSchema]
});

exports.Food = mongoose.model('Food', foodSchema);

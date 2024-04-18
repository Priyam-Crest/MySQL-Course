var express = require('express');
var mysql = require('mysql2');
var bodyParser = require("body-parser");
 
var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  database: 'join_us'
});
 
var app = express();

app.set("view engine","ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname + "/public"));
 
app.get("/", function(req, res){
  var q = 'SELECT COUNT(*) as count FROM users';
  connection.query(q, function (error, results) {
  if (error) throw error;
  var count = results[0].count;
  // var msg = "We have " + results[0].count + " users";
  // res.send(msg);
  res.render("home", {counter : count});
  });
 });


 app.post("/register", function(req,res){
  // var email_name = req.body.email;
  var person = {email:req.body.email};
  // console.log(email_name);
  connection.query('INSERT INTO users SET ?',person, function(error,results){
    if (error) throw error;
    res.redirect("/");
  });
 });

app.get("/joke", function(req,res){
  res.send("Knock Knock..!!");
});

app.get("/number", function(req,res){
  res.send(Math.ceil(Math.random()*10).toString());
});
 
app.listen(8080, function () {
 console.log('App listening on port 8080!');
});


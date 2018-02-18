var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var app = express();
var server = require("http").createServer(app);
var io = require("socket.io").listen(server);
var Message = require('./models/message');

mongoose.connect('mongodb://127.0.0.1/socketchat-server', function (err) {
    if(err) {
        throw err
    }
    console.log('Connect mongodb success!');
    io.sockets.on('connection', function (socket) {
        console.log('Have a client connected...');
        Message.find(function (err, data) {
            console.log(data);
            socket.emit('all-message', {messages : data});
        });
        socket.on('new_message', function (data) {
           var newMessage = new Message({
               user: data.user,
               message: data.message
           });
           console.log(newMessage);
           newMessage.save(function (err) {
               if(!err) {
                   console.log('Add a new message');
                   socket.emit('send-message', {message : newMessage})
               } else {
                   console.log('Add message error');
               }
           })
        });
        socket.on('clear', function () {
            Message.remove(function (err) {
                if(!err) {
                    console.log('Remove all message');
                }
            });
        })
    });
});

var index = require('./routes/index');
var users = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', index);
app.use('/users', users);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

server.listen(process.env.POST || 3000);

module.exports = app;

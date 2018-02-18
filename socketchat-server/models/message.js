var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var MessageSchema = new Schema({
   user: {
       type: String,
       unique: true,
       required: true
   },
   message: {
       type: String,
       unique: true,
       required: true
   }
});

module.exports = mongoose.model('Message', MessageSchema);
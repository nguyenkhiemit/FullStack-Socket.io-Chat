import {Component, OnInit} from '@angular/core';
import * as io from 'socket.io-client';
import {} from '..s'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'app';

  socket = io.connect("http://localhost:3000/");

  arrayMessage = [];

  user = '';

  newMessage = '';

  constructor() {

  }

  ngOnInit(): void {
    if(this.socket !== undefined) {
      console.log('Connected to socket...');

      this.socket.on('all-message', (data) => {
        this.arrayMessage = [];
        var messages = data.messages;
        for(var i = 0; i < messages.length; i++) {
           this.arrayMessage.push(messages[i].user + ' : ' + messages[i].message);
        }
      });

      this.socket.on('send-message', (data) => {
        var message = data.message;
        this.arrayMessage.push(message.user + ' : ' + message.message);
      });

      this.socket.on('output', function (data) {
        console.log(data);
      });
    }
  }

  sendMessage() {
    if(this.user == ''||this.newMessage == '') {
      alert('User name or message have no string!');
      return;
    }
    this.socket.emit('new_message', {user: this.user, message: this.newMessage});
    this.user = '';
    this.newMessage = '';
  }

  clearMessage() {
    this.socket.emit('clear');
    this.arrayMessage = [];
  }
}

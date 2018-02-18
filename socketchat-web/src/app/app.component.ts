import {Component, OnDestroy, OnInit} from '@angular/core';
import * as io from 'socket.io-client';
import {} from '..s'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, OnDestroy {
  title = 'app';

  socket = io.connect("http://localhost:3000/");

  arrayMessage = [];

  user = '';

  newMessage = '';

  hidden = true;

  constructor() {

  }

  ngOnInit(): void {
    if(this.socket !== undefined) {
      console.log('Connected to socket...');

      this.socket.on('connected', () => {
        this.hidden = false
      });

      this.socket.on('all-message', (data) => {
        this.arrayMessage = [];
        var messages = data.messages;
        for(var i = 0; i < messages.length; i++) {
           this.arrayMessage.push(messages[i].user + ' : ' + messages[i].message);
        }
      });

      this.socket.on('send-message', (data) => {
        this.arrayMessage.push(data.user + ' : ' + data.message);
      });
    }
  }

  ngOnDestroy() {
    this.socket.disconnect();
    this.socket.off('connected');
    this.socket.off('all-message');
    this.socket.off('send-message');
  }

  sendMessage() {
    if(this.user == ''||this.newMessage == '') {
      alert('User name or message have no string!');
      return;
    }
    this.socket.emit('new-message', {user: this.user, message: this.newMessage});
    this.user = '';
    this.newMessage = '';
  }

  clearMessage() {
    this.socket.emit('clear');
    this.arrayMessage = [];
  }
}

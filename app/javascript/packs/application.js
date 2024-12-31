import { ChatChannel } from "channels/chat_channel.js";

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", () => {
    const messageInput = document.getElementById("chat-message-input");
    const form = document.getElementById("chat-message-form");
  
    form.addEventListener("submit", (e) => {
      e.preventDefault();
  
      const message = messageInput.value;
      if (message) {
        chatChannel.sendMessage(message); // Send message via WebSocket
        messageInput.value = ''; // Clear input field
      }
    });
  });

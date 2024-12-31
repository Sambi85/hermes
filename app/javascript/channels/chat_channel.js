import consumer from "./consumer";

// Fetch the conversation ID from the HTML element with data-conversation-id
const conversationId = document.getElementById("chat").getAttribute("data-conversation-id");

const chatChannel = consumer.subscriptions.create(
  { channel: "ChatChannel", conversation_id: conversationId }, // Pass conversation_id to the channel
  {
    connected() {
      console.log("Connected to the chat!");
    },

    disconnected() {
      console.log("Disconnected from chat.");
    },

    received(data) {
      // Get the current user's username from the page (assuming it's available on the page)
      const currentUser = document.getElementById('current_user').getAttribute('data-username');
      const messagesDiv = document.getElementById("messages");

      const messageDiv = document.createElement("div");
      messageDiv.classList.add("message");

      // Check if the message is from the current user or a recipient
      const messageClass = data.user === currentUser ? 'sender' : 'recipient';

      messageDiv.classList.add(messageClass);

      // Create message elements
      const usernameDiv = document.createElement("span");
      usernameDiv.classList.add("username");
      usernameDiv.innerText = data.user;

      const messageTextDiv = document.createElement("span");
      messageTextDiv.classList.add("message-text");
      messageTextDiv.innerText = data.message;

      // Append the username and message text to the message div
      messageDiv.appendChild(usernameDiv);
      messageDiv.appendChild(messageTextDiv);

      // Add the message div to the messages container
      messagesDiv.appendChild(messageDiv);

      // Scroll to the bottom of the messages container
      messagesDiv.scrollTop = messagesDiv.scrollHeight;
    },

    sendMessage(message) {
      // Send the message to the server via WebSocket
      this.perform("send_message", { message: message });
    }
  }
);

// Event listener to handle message sending
document.getElementById("send_button").addEventListener("click", function() {
  const messageInput = document.getElementById("message_input");
  const message = messageInput.value.trim(); // Ensure no empty messages are sent
  
  if (message) {
    chatChannel.sendMessage(message); // Send the message via WebSocket
    messageInput.value = ''; // Clear input field after sending
  } else {
    console.log("Message cannot be empty");
  }
});

// Optional: Allow pressing 'Enter' to send the message
document.getElementById("message_input").addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    document.getElementById("send_button").click();
  }
});
import consumer from "./consumer"

const chatChannel = (conversationId) => {
  return consumer.subscriptions.create({ channel: "ChatChannel", conversation_id: conversationId }, {
    connected() {
      console.log("Connected to chat channel for conversation " + conversationId);
    },

    disconnected() {
      console.log("Disconnected from chat channel");
    },

    received(data) {
      console.log("Received data:", data);
      // Append the message to the UI
      const messageElement = document.createElement("div");
      messageElement.innerHTML = `${data.user}: ${data.message}`;
      document.getElementById("messages").appendChild(messageElement);
    },

    send_message(message) {
      // Send a message to the backend
      this.perform('send_message', { message: message });
    }
  });
}

export default chatChannel;

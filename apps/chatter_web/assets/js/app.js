import socket from "./socket"
import chat from "./chat"

const hash = window.location.hash.substr(1)

if (window.CHAT) {
  chat.init(socket, document, hash)
}

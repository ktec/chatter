import socket from "./socket"
import chat from "./chat"
import particle from "./particle"

const hash = window.location.hash.substr(1)

if (window.CHAT) {
  chat.init(socket, document, hash)
}

if (window.PARTICLES) {
  particle(socket, "body", hash)
}

import {Socket} from "phoenix"
import chat from "./chat"

const hash = window.location.hash.substr(1)
const token = document.head.querySelector("[name=token]").content
const socket = new Socket("/socket", {params: {token: token}})
socket.connect()

if (window.CHAT) {
  chat.init(socket, document, hash, token)
}

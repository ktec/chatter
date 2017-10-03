import {getCookie, setCookie} from "./cookie"
import {joinChannel} from "./channel"

const ENTER_KEY = 13

const init = (socket, document, hash) => {
  const room = getRoom(hash)
  const username = document.getElementById("username")
  const message = document.getElementById("message")
  const messages = document.getElementById("messages")

  // set username form
  username.value = getCookie('username')

  // join the channel
  const channel = joinChannel(socket, hash, room, response => {
    console.log("Joined successfully")
    response.map(renderMessage(messages))
  })

  // add listener for keypress
  message.addEventListener("keypress",
    keyPressHandler(username, message, channel)
  )

  // add lister for channel messages
  channel.on("new_message", renderMessage(messages))
}

const keyPressHandler = (username, message, channel) => {
  return (event) => {
    setCookie('username', username.value, 3)

    if (event.charCode == ENTER_KEY) {
      channel.push("new_message", {
        user: username.value,
        body: replaceEmoji(message.value)
      })
      message.value = ""
    }
  }
}

const renderMessage = (messages) => ({user, body}) => {
  const new_message = `<p><b>[${user || "anon"}]</b>: ${body}</p>`
  messages.insertAdjacentHTML('beforeend', new_message)
  messages.scrollTop = messages.scrollHeight
}

const replaceEmoji = (str) => {
  str.replace(/\:\)/g, "☺")
     .replace(/<3/g, "♡")
     .replace(/:kiss:/g, "💋")
}

const getRoom = (hash) => {
  return "room:" + (hash || "lobby")
}

export default {init: init}

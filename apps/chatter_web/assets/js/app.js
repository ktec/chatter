import socket from "./socket"
import {getCookie, setCookie} from "./cookie"

(() => {
  const ENTER_KEY = 13
  const init = (socket, document) => {
    const username = document.getElementById("username")
    const message = document.getElementById("message")
    const messages = document.getElementById("messages")

    username.value = getCookie('username')

    let channel = socket.channel("room:lobby", {})
    channel.join()
      .receive("ok", response => {
        console.log("Joined successfully")
        response.map(renderMessage(messages))
      })
      .receive("error", response => {
        console.log("Unable to join", response)
      })

    message.addEventListener("keypress",
      keyPressHandler(username, message, channel)
    )

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

  const replaceEmoji = (str) =>
    str.replace(/\:\)/g, "☺")
       .replace(/<3/g, "♡")
       .replace(/:kiss:/g, "💋")

  init(socket, document)
})(this)

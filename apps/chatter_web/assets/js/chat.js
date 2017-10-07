import {Presence} from "phoenix"
import {getCookie, setCookie} from "./cookie"
import {joinChannel} from "./channel"

const ENTER_KEY = 13

const init = (socket, document, hash, token) => {
  const room = getRoom(hash)
  const username = document.getElementById("username")
  const messageInput = document.getElementById("message-input")
  const messages = document.getElementById("messages")
  let userId = ""
  let presences = {}

  // set username form
  username.value = getCookie('username')

  const userMessage = ({user, body}) => `<p><b>[${sanitize(user || "anon")}]</b>: ${sanitize(body)}</p>`
  const systemMessage = ({body}) => `<p><i>${body}</i></p>`

  // join the channel
  const channel = joinChannel(socket, hash, room, response => {
    console.log(`Joined ${room} successfully.`)
    console.log("User ID: ", response.user_id)
    userId = response.user_id
    if (response.error) {
      console.log(response.error)
      return
    }
    response.messages.map(renderMessage(messages, userMessage))
  })

  // const updatePresences = (presences) => {
  //   console.log(presences)
  // }

  // handle presences
  channel.on("presence_state", state => {
    // console.log("presence_state", state)
    // renderMessage(messages, systemMessage)({body: "Somebody joined the conversation"})
    // Presence.syncState(presences, state)
    // updatePresences(presences)
  })
  channel.on("presence_diff", diff => {
    const {leaves} = diff
    Object.keys(leaves).map((key) => {
        console.log("Someone left", key)
    //   renderMessage(messages, systemMessage)({body: "Somebody left the conversation"})
    //   delete presences[key]
    })

    const {joins} = diff
    Object.keys(joins).map((key) => {
      if (key == userId) {return}
      console.log("Someone joined", key)
    //   renderMessage(messages, systemMessage)({body: "Somebody left the conversation"})
    //   delete presences[key]
    })

    // Presence.syncDiff(presences, diff)
    // updatePresences(presences)
  })

  // add listener for keypress
  messageInput.addEventListener("keypress",
    keyPressHandler(username, messageInput, channel)
  )

  // add lister for channel messages
  channel.on("new_message", renderMessage(messages, userMessage))
}

const keyPressHandler = (username, messageInput, channel) => {
  return (event) => {
    setCookie('username', username.value, 3)

    if (event.charCode == ENTER_KEY) {
      const payload = {
        user: username.value,
        body: replaceEmoji(messageInput.value)
      }
      channel.push("new_message", payload)
      messageInput.value = ""
    }
  }
}

const renderMessage = (messages, format) => (payload) => {
  messages.insertAdjacentHTML('beforeend', format(payload))
  messages.scrollTop = messages.scrollHeight
}

const replaceEmoji = (str) => {
  return (
    str.replace(/\:\)/g, "☺")
       .replace(/<3/g, "♡")
       .replace(/:kiss:/g, "💋")
  )
}

const getRoom = (hash) => {
  return "room:" + (hash || "lobby")
}

const sanitize = (input) => {
  return input.replace(/<script[^>]*?>.*?<\/script>/gi, '*')
              .replace(/<[\/\!]*?[^<>]*?>/gi, '*')
              .replace(/<style[^>]*?>.*?<\/style>/gi, '*')
              .replace(/<![\s\S]*?--[ \t\n\r]*>/gi, '*')
}

export default {init: init}

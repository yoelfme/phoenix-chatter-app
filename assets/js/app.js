import 'phoenix_html'
import { Socket, Presence } from 'phoenix'

let user = document.getElementById('user').innerHTML
let socket = new Socket('/socket', { params: { user } })

socket.connect()
socket.onOpen( ev => console.log("OPEN", ev) )
socket.onError( ev => console.log("ERROR", ev) )
socket.onClose( e => console.log("CLOSE", e))

let presences = {}

let formatedTimestamp = (ts) => {
    let date = new Date(ts)

    return date.toLocaleString()
}

let listBy = (user, { metas }) => {
    console.log('################')
    console.log(metas[0].online_at)
    console.log('################')
    

    return {
        user,
        onlineAt: formatedTimestamp(metas[0].online_at)
    }
}

let userList = document.getElementById('userList')
let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
        .map(presence => `
            <li>
                ${presence.user}
                <br>
                <small>online since ${presence.onlineAt}</small>
            </li>
        `)
        .join('')
}

let room = socket.channel('room:lobby')

room.on('presence_state', (state) => {
    presences = Presence.syncState(presences, state)
    render(presences)
})

room.on('presence_diff', (state) => {
    presences = Presence.syncDiff(presences, state)
    render(presences)
})

room.join().receive('error', (e) => console.error(e))
room.onError(e => console.log('something went wrong', e))
room.onClose(e => console.log('channel closed', e))

let messageInput = document.getElementById('newMessage')

messageInput.addEventListener('keypress', (e) => {
    if (e.keyCode == 13 && messageInput.value != '') {
        room.push('message:new', messageInput.value)
        messageInput.value = ''
    }
})

let messageList = document.getElementById('messageList')
let renderMessage = (message) => {
    let messageElement = document.createElement('li')

    messageElement.innerHTML = `
        <b>${message.user}</b>
        <i>${formatedTimestamp(message.timestamp)}</i>
        <p>${message.body}</p>
    `

    messageList.appendChild(messageElement)
    messageList.scrollTop = messageList.scrollHeight
}

room.on('message:new', renderMessage)
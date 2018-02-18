package newgate.com.socketchat

import com.github.nkzawa.socketio.client.IO
import com.github.nkzawa.socketio.client.Socket
import org.json.JSONObject
import java.net.URISyntaxException

/**
 * Created by apple on 2/18/18.
 */
class SocketUtils {

    lateinit var socket: Socket

    companion object {
        var instanceSocketUtils: SocketUtils? = null
        fun getInstance(): SocketUtils {
            if(instanceSocketUtils == null) {
                instanceSocketUtils = SocketUtils()
            }
            return instanceSocketUtils!!
        }
    }

    fun init() {
        try {
            socket = IO.socket("http://192.168.1.5:3000")
        } catch (e: URISyntaxException) {

        }
    }

    fun connect(listener: OnConnectListener) {
        socket.connect()
        socket.on("connected") {
            listener.connect()
        }
    }

    fun getAllMessages(): ArrayList<Message> {
        var arrayMessage = ArrayList<Message>()
        socket.on("all-message") {
            args -> val data = args[0] as JSONObject
            var jsonArray = data.getJSONArray("messages")
            for(i in 0 until jsonArray.length()) {
                var jsonObject = jsonArray[i] as JSONObject
                var message = Message(jsonObject.get("user").toString(), jsonObject.get("message").toString())
                arrayMessage.add(message)
            }
        }
        return arrayMessage
    }

    fun sendNewMessage(user: String, message: String) {
        var messageJson = JSONObject()
        messageJson.put("user", user)
        messageJson.put("message", message)
        socket.emit("new-message", messageJson)
    }

    fun receiveNewMessage(listener: OnMessageListener){
        var message: Message? = null
        socket.on("send-message") {
            args -> val data = args[0] as JSONObject
            message = Message(data.get("user").toString(), data.get("message").toString())
            listener.receiveMessage(message)
        }
    }

    fun clear() {
        socket.emit("clear")
    }

    fun disconnect() {
        socket.disconnect()
        socket.off("connected")
        socket.off("all-message")
        socket.off("send-message")

    }

    interface OnMessageListener {
        fun receiveMessage(message: Message?)
    }

    interface OnConnectListener {
        fun connect()
    }
}
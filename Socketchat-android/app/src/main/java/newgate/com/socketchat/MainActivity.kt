package newgate.com.socketchat

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.view.View
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    private val socketUtils = SocketUtils.getInstance()

    private var arrayMessage = arrayListOf<Message>()

    val adapter by lazy {
        MessageAdapter(arrayMessage)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        socketUtils.init()
        arrayMessage = socketUtils.getAllMessages()
        socketUtils.connect(object: SocketUtils.OnConnectListener {
            override fun connect() {
               runOnUiThread {
                   statusText.visibility = View.VISIBLE
               }
            }
        })

        messageRecyclerView.layoutManager = LinearLayoutManager(this)
        messageRecyclerView.adapter = adapter

        sendButton.setOnClickListener {
            socketUtils.sendNewMessage(usernameEditText.text.toString(), newMessageEditText.text.toString())
            usernameEditText.setText("")
            newMessageEditText.setText("")
        }

        clearButton.setOnClickListener {
            socketUtils.clear()
            arrayMessage.clear()
            adapter.notifyDataSetChanged()
        }

        socketUtils.receiveNewMessage(object: SocketUtils.OnMessageListener {

            override fun receiveMessage(message: Message?) {
                if(message != null) {
                    arrayMessage.add(message)
                    runOnUiThread {
                        adapter.notifyDataSetChanged()
                    }
                }
            }

        })
    }

    override fun onDestroy() {
        super.onDestroy()
        socketUtils.disconnect()
    }
}

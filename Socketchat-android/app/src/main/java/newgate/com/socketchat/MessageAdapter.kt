package newgate.com.socketchat

import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import kotlinx.android.synthetic.main.layout_item_message.view.*

/**
 * Created by apple on 2/18/18.
 */
class MessageAdapter(val arrayMessage: ArrayList<Message>): RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.layout_item_message, parent, false)
        return MessageViewHoler(view)
    }

    override fun getItemCount(): Int {
        return arrayMessage.count()
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder?, position: Int) {
        if(holder is MessageViewHoler) {
            holder.fillData(arrayMessage[position])
        }
    }

    class MessageViewHoler(var view: View): RecyclerView.ViewHolder(view) {
        fun fillData(message: Message) {
            view.usernameTextView.text = message.username
            view.messageTextView.text = message.message
        }
    }
}
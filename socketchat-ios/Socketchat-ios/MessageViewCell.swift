//
//  MessageViewCell.swift
//  Socketchat-ios
//
//  Created by Nguyen on 2/19/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillData(message: Message) {
        userLabel.text = message.user
        messageLabel.text = message.message
    }

}

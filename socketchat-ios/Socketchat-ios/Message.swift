//
//  Message.swift
//  Socketchat-ios
//
//  Created by Nguyen on 2/19/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class Message: NSObject {

    var user: String
    var message: String

    init(user: String, message: String) {
        self.user = user
        self.message = message
    }
}

//
//  ViewController.swift
//  Socketchat-ios
//
//  Created by Nguyen on 2/18/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

    let socketManager = SocketIOManager.sharedInstance

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var messageTextField: UITextField!

    var arrayMessage = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        socketManager.getAllMessage() {
            [weak self] arrayMessage in
            self?.arrayMessage = arrayMessage
            self?.tableView.reloadData()
        }
        socketManager.receiveNewMessage() {
            [weak self] message in
            self?.arrayMessage.append(message)
            self?.tableView.reloadData()
        }
        socketManager.connect() {
            self.statusLabel.isHidden = false
        }

        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func sendNewMessage(_ sender: Any) {
        if let username = usernameTextField.text, let message = messageTextField.text {
             socketManager.sendNewMessage(user: username, message: message)
            usernameTextField.text = ""
            messageTextField.text = ""
        }
    }

    @IBAction func clear(_ sender: Any) {
        socketManager.clear()
        arrayMessage.removeAll()
        tableView.reloadData()
    }

    deinit {
        socketManager.disconnect()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMessage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell", for: indexPath) as! MessageViewCell
        cell.fillData(message: arrayMessage[indexPath.item])
        return cell
    }
}


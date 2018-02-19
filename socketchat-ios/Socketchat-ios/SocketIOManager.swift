//
//  SocketUtils.swift
//  Socketchat-ios
//
//  Created by Nguyen on 2/19/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

     let manager = SocketManager(socketURL: URL(string: "http://192.168.1.5:3000")!, config: [.log(true), .compress])

    lazy var socket: SocketIOClient? = {
        return manager.defaultSocket
    }()

    typealias connectedListener = () -> Void

    typealias getAllMessageListener = (_ arrayMessage: [Message]) -> Void

    typealias getMessage = (_ message: Message) -> Void

    override init() {
        super.init()
    }

    func connect(complete: @escaping connectedListener) {
        self.socket?.connect()
        socket?.on("connected", callback: { (data, ack) in
            complete()
        })
    }

    func getAllMessage(complete: @escaping getAllMessageListener) {
        var arrayMessage = [Message]()
        socket?.on("all-message", callback: {(data, ack) in
            guard let jsonData = data[0] as? [String: Any] else {
                return
            }
            guard let jsonArray = jsonData["messages"] as? [[String: Any]] else {
                return
            }
            for i in 0 ..< jsonArray.count {
                if let jsonObject: [String: Any] = jsonArray[i] as? [String: Any] {
                    let message = Message(user: jsonObject["user"] as! String, message: jsonObject["message"] as! String)
                    arrayMessage.append(message)
                }
            }
            complete(arrayMessage)
        })
    }

    func sendNewMessage(user: String, message: String) {
        let dicMessage = ["user": user, "message": message]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dicMessage, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data

            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data

            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                socket?.emit("new-message", dictFromJSON)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func receiveNewMessage(complete: @escaping getMessage) {
        socket?.on("send-message", callback: { (data, ack) in
            guard let jsonData = data[0] as? [String: Any] else {
                return
            }
            let message = Message(user: jsonData["user"] as! String, message: jsonData["message"] as! String)
            complete(message)
        })
    }

    func clear() {
         socket?.emit("clear")
    }

    func disconnect() {
        socket?.disconnect()
        socket?.off("connected")
        socket?.off("all-message")
        socket?.off("send-message")
    }
}

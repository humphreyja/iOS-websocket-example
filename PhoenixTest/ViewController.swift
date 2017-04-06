//
//  ViewController.swift
//  PhoenixTest
//
//  Created by Jake Humphrey on 11/5/16.
//  Copyright © 2016 Jake Humphrey. All rights reserved.
//

import UIKit
import SwiftPhoenixClient

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let socket = Socket(domainAndPort: "localhost:4000", path: "socket", transport: "websocket", params: ["user":"iPhone"])
    
    var messageQueue: [SockMessage] = []
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var connectedState: UIProgressView!
    @IBOutlet weak var enterMessage: UITextField!
    
    struct SockMessage {
        let message: String
        let user: String
        let timestamp: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectedState.progress = 1

        
        messageTable.dataSource = self
        messageTable.delegate = self
        enterMessage.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        
        socket.join(topic: "room:lobby", message: Message(message: ["msg": "Hello"])) { channel in
            
            let chan = channel as! Channel
            
            chan.on(event: "phx_join") { message in
                self.connectedState.progress = 1
            }
            
            chan.on(event: "message:new") { message in
                guard let message = message as? Message,
                    let username = message["user"],
                    let timestamp = message["timestamp"],
                    let body     = message["body"] else {
                        return
                }
                let newMessage = SockMessage(message: body as! String, user: username as! String, timestamp: timestamp as! Int)
                self.messageQueue.append(newMessage)
                let lastIndex = IndexPath(row: self.messageQueue.count - 1, section: 0)
                self.messageTable.insertRows(at: [lastIndex], with: .automatic)
                
                print(self.messageQueue)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let message = Message(message: ["msg":textField.text])
        
        
        let payload = Payload(topic: "room:lobby", event: "message:new", message: message)
        socket.send(data: payload)
        textField.text = ""
        self.view.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageQueue.count
    }
    
    @IBOutlet weak var tableCell: UITableViewCell!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let msg = messageQueue[indexPath.row].message
        let user = messageQueue[indexPath.row].user
        
        
        cell.textLabel?.text = "["+user+"] " + msg
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: messageQueue[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! DetailedController
        let msg = sender as! SockMessage
        
        guest.t_personName = msg.user
        guest.t_personMessage = msg.message
        guest.t_personDateTime = Double(msg.timestamp)
    }
    

}


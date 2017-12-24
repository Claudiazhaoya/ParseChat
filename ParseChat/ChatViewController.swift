//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Zhaoya Sun on 12/9/17.
//  Copyright © 2017 Zhaoya Sun. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messageArray:[PFObject] = []
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var textMessage: UITextField!
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = textMessage.text, !text.isEmpty else {
            return
        }
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = textMessage.text ?? ""
        chatMessage["user"] = PFUser.current()!
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        textMessage.text = ""
    }
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateInitialViewController()
        present(chatViewController!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 50
        chatTableView.separatorStyle = .none
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let text = messageArray[indexPath.row]
        cell.textMess.text = text["text"] as? String ?? ""
        if let user = text["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "🤖"
        }
    
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        // Auto size row height based on cell autolayout constraints
        chatTableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        chatTableView.estimatedRowHeight = 50
        fetchMessage()
        // Do any additional setup after loading the view.
    }
      
    
    @objc func fetchMessage() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(1e9))) {
            let query = PFQuery(className: "Message")
            query.addAscendingOrder("createdAt")
            query.includeKey("user")
            
            query.findObjectsInBackground(block: { (messages, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.fetchMessage()
                } else if let messages = messages {
                    self.messageArray = messages
                    DispatchQueue.main.async {
                        self.chatTableView.reloadData()
                        self.fetchMessage()
                    }
                }
            })
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

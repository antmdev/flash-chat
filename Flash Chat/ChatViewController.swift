//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
       
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
       


        //TODO: Set yourself as the delegate of the text field here:

        messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        
        
        
        //TODO: Register your MessageCell.xib file here:
         messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        
        
       
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        //set colours based on whether or not you are the logged in user
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!
        {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
            
        }
        
        return cell //requires an output
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count // number of rows required
    }
    
// if you want sections in your table view like ios settings
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0

    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
       //increase heght constraint to accomodate keyboard
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConstraint.constant = 369 //xsmax keyboard size (308 for iphone 8)
            self.view.layoutIfNeeded() //if something in view has changed re-draw the whole thing
                   
        })
        
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //increase heght constraint to accomodate keyboard
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
                   
        })
        
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.endEditing(true) //close text editer
        messageTextfield.isEnabled = false//disable text message after sending
        sendButton.isEnabled = false
        
        //send button creates a reference to new db in side our db
        let messagesDB = Database.database().reference().child("Messages")
        
        //save message as dictionary as key-value pairs
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        //saving message dictionary in messages DB under automatically generated identifier
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Message saved succesfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
            
        
        
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            // set the value in the DB by declaring that its a string-string dictionary.
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text //set message object in ethe message class
            message.sender = sender
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData() //everytime we add new data to DB it will reload data so its shown.
        })
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do {
            try Auth.auth().signOut() //signs out the user (can throw error so put inside do-catch block)
            
            navigationController?.popViewController(animated: true)
        }
        catch {
            print("Error, there was a problem signing out")
        }
    


}
}

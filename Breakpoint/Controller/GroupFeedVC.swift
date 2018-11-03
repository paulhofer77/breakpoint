//
//  GroupFeedVC.swift
//  Breakpoint
//
//  Created by Paul Hofer on 03.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var messageTextfield: InsetTextfield!
    @IBOutlet weak var sendButton: UIButton!
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initDate(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButtonView.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.membersLabel.text = returnedEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
        
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if messageTextfield.text != nil {
            sendButton.isEnabled = false
            messageTextfield.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextfield.text!, forUID: Auth.auth().currentUser!.uid, withGroupKEy: group?.key) { (complete) in
                if complete {
                    self.messageTextfield.text = ""
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                }
            }
        }
        
        
    }
    
    
}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else {return UITableViewCell() }
        
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getUserName(forUID: message.senderId) { (email) in
           cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
        return cell
    }
    
    
    
}

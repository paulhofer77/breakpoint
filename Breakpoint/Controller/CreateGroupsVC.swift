//
//  CreateGroupsVC.swift
//  Breakpoint
//
//  Created by Paul Hofer on 02.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    
    //    MARK: - Outlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextfield: InsetTextfield!
    @IBOutlet weak var groupMemberLabel: UILabel!
    @IBOutlet weak var descriptionTextfield: InsetTextfield!
    @IBOutlet weak var emailSearchTextfield: InsetTextfield!
    
    
    //    MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextfield.delegate = self

        emailSearchTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isHidden = true
    }

    
    @objc func textFieldDidChange() {
        
        if emailSearchTextfield.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextfield.text!) { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    //    MARK: - Button Function
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if titleTextfield.text != "" && descriptionTextfield.text != "" {
            DataService.instance.getIds(forUserNames: chosenUserArray) { (returnedUserIds) in
                
                var userIds = returnedUserIds
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.titleTextfield.text!, andDescription: self.descriptionTextfield.text!, forUserIds: userIds, handler: { (groupCreated) in
                    
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Group could not be created")
                    }
                })
            }
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}





//MARK: - TableView Methods
extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        
        let profileImage = UIImage(named: "defaultProfileImage")
        let email = emailArray[indexPath.row]
        if chosenUserArray.contains(email) {
            cell.configureCell(profileImage: profileImage!, email: email, isSelected: true)
        } else {
            cell.configureCell(profileImage: profileImage!, email: email, isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!)
            groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            doneButton.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! })
            if chosenUserArray.count >= 1 {
                groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
                
            } else {
                groupMemberLabel.text = "add people to your group"
                doneButton.isHidden = true
            }
        }
    }
    
    
    
}

extension CreateGroupsVC: UITextFieldDelegate {
    
    
    
}

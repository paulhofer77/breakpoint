//
//  SecondViewController.swift
//  Breakpoint
//
//  Created by Paul Hofer on 01.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import Firebase

class GroupsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.tableView.reloadData()
            }
        }
    }

    
}


extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell else { return UITableViewCell()}
        
        let group = groupsArray[indexPath.row]
        
        cell.configureCell(title: group.groupTitle, description: group.groupDescription, memberCount: group.memberCount)
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else {return}
        groupFeedVC.initDate(forGroup: groupsArray[indexPath.row])
        presentDetail(groupFeedVC)
//        present(groupFeedVC, animated: true, completion: nil)
        
    }
    
    
}

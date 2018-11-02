//
//  MeVC.swift
//  Breakpoint
//
//  Created by Paul Hofer on 01.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    //    MARK: - Outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLable: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLable.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        
        let logoutPopup = UIAlertController(title: "Logout", message: "You really wanna Log Out?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    

}

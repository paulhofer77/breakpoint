//
//  LoginVC.swift
//  Breakpoint
//
//  Created by Paul Hofer on 01.11.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    
    @IBOutlet weak var emailTextfield: InsetTextfield!
    
    @IBOutlet weak var passwortTextfield: InsetTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.delegate = self
        passwortTextfield.delegate = self
    }
    

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        if emailTextfield.text != nil && passwortTextfield.text != nil {
            AuthService.instance.loginUser(withEmail: emailTextfield.text!, andPassword: passwortTextfield.text!) { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("LOGIN ERROR at FIRST LOGIN")
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailTextfield.text!, andPassword: self.passwortTextfield.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
//                        AuthService.instance.loginUser(withEmail: self.emailTextfield.text!, andPassword: self.passwortTextfield.text!, loginComplete: { (succes, nil) in
//                            self.dismiss(animated: true, completion: nil)
//                        })
                    } else {
                        print("LOGIN ERROR at Registration")
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })
            }
        }
        
        
    }
    

}





extension LoginVC: UITextFieldDelegate {
    
}

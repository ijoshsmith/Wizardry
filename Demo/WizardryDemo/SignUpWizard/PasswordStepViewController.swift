//
//  PasswordStepViewController.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/4/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// Displays the second step in the Sign Up Wizard, where the new user's password is entered.
final class PasswordStepViewController: UIViewController {
    
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    /// The password to display when the view is first shown.
    var initialPassword: String?
    
    /// The proposed password entered into the text field.
    var currentPassword: String? {
        if let password = passwordTextField.text {
            return password.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        else {
            return nil
        }
    }
    
    /// Clears out the password text field.
    func eraseCurrentPassword() {
        passwordTextField.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.text = initialPassword
        passwordTextField.becomeFirstResponder()
    }
}

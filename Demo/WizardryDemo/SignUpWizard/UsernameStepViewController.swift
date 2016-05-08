//
//  UsernameStepViewController.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/2/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// Displays the first step in the Sign Up Wizard, where a username is entered and validated.
final class UsernameStepViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var usernameTextField: UITextField!
    
    /// The username to display when the view is first shown.
    var initialUsername: String?
    
    /// The proposed username entered into the text field.
    var currentUsername: String? {
        if let username = usernameTextField.text {
            return username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        else {
            return nil
        }
    }
    
    /// This is set to true when asking the server if the current username is available.
    var isCheckingUsernameAvailability: Bool = false {
        didSet {
            if isCheckingUsernameAvailability {
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
            }
            usernameTextField.userInteractionEnabled = (isCheckingUsernameAvailability == false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = initialUsername
        usernameTextField.becomeFirstResponder()
    }
}

//
//  SubmitStepViewController.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/5/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// Displays the third and final step in the Sign Up Wizard, where the new user's account is created.
final class SubmitStepViewController: UIViewController {
    
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var submitButton: UIButton!
    @IBOutlet fileprivate weak var wantsNewsletterSwitch: UISwitch!
    
    /// The preference for receiving an email newsletter when the view is first shown.
    var initialWantsNewsletter: Bool!
    
    /// The selected preference for receiving an email newsletter.
    var currentWantsNewsletter: Bool {
        return wantsNewsletterSwitch.isOn
    }
    
    /// This is set to true when calling a service to create the new user's account.
    var isRegisteringUser = false {
        didSet {
            if isRegisteringUser {
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
            }
            submitButton.alpha = isRegisteringUser ? 0.25 : 1.0
            submitButton.isEnabled = (isRegisteringUser == false)
            wantsNewsletterSwitch.isUserInteractionEnabled = (isRegisteringUser == false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This wizard step does not have a Next button in the navigation bar. Instead we hook up the button to invoke the same method
        // in SignUpWizardViewController that the Next button would invoke, which causes the wizard to try to transition to the next step.
        // Passing nil as the target enables the event to bubble up the responder chain until it finds the SignUpWizardViewController.
        submitButton.addTarget(nil, action: #selector(SignUpWizardViewController.handleGoToNextStep(_:)), for: .touchUpInside)
        
        wantsNewsletterSwitch.isOn = initialWantsNewsletter
    }
}

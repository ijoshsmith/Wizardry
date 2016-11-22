//
//  UsernameWizardStep.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/4/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit
import Wizardry

/// The first step in the Sign Up Wizard, where a username is entered and validated by a service call.
final class UsernameWizardStep {
    
    fileprivate let model: SignUpWizardModel
    fileprivate let usernameStepViewController: UsernameStepViewController
    
    init(model: SignUpWizardModel) {
        self.model = model
        
        let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
        usernameStepViewController = (storyboard.instantiateViewController(withIdentifier: "username") as! UsernameStepViewController)
        usernameStepViewController.initialUsername = model.username
    }
}



// MARK: - WizardStep conformance

extension UsernameWizardStep: WizardStep {
    
    var viewController: UIViewController {
        return usernameStepViewController
    }
    
    func doWorkBeforeWizardGoesToNextStepWithCompletionHandler(_ completionHandler: @escaping (_ shouldGoToNextStep: Bool) -> Void) {
        guard let username = usernameStepViewController.currentUsername, isValidUsername(username) else {
            completionHandler(false)
            return
        }
        
        usernameStepViewController.isCheckingUsernameAvailability = true
        UsernameService.checkIfAvailable(username) { isUsernameAvailable in
            self.usernameStepViewController.isCheckingUsernameAvailability = false
            
            if isUsernameAvailable {
                self.model.username = username
            }
            else {
                self.showUsernameUnavailableAlert()
            }
            
            completionHandler(shouldGoToNextStep: isUsernameAvailable)
        }
    }
    
    func doWorkBeforeWizardGoesToPreviousStepWithCompletionHandler(_ completionHandler: (_ shouldGoToPreviousStep: Bool) -> Void) {
        // There's no need to copy the current username to the data model, because going back from this step cancels the wizard.
        
        // Take the view out of edit mode, to immediately dismiss the keyboard, otherwise it stays around for a moment too long.
        usernameStepViewController.view.endEditing(true)
        
        completionHandler(true)
    }
}



// MARK: - Private methods

private extension UsernameWizardStep {
    
    func isValidUsername(_ username: String) -> Bool {
        return username.characters.count > 0
    }
    
    func showUsernameUnavailableAlert() {
        let alert = UIAlertController(
            title: "Username Unavailable",
            message: "Please choose a different username.",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        usernameStepViewController.show(alert, sender: usernameStepViewController)
    }
}

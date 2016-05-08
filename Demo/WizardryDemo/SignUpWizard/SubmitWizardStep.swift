//
//  SubmitWizardStep.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/5/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit
import Wizardry

/// The third and final step in the Sign Up Wizard, where the new user's account is created.
final class SubmitWizardStep {
    
    private let model: SignUpWizardModel
    private let submitStepViewController: SubmitStepViewController
    
    init(model: SignUpWizardModel) {
        self.model = model
        
        let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
        submitStepViewController = (storyboard.instantiateViewControllerWithIdentifier("submit") as! SubmitStepViewController)
        submitStepViewController.initialWantsNewsletter = model.wantsNewsletter
    }
}



// MARK: - WizardStep conformance

extension SubmitWizardStep: WizardStep {
    
    var viewController: UIViewController {
        return submitStepViewController
    }
    
    func doWorkBeforeWizardGoesToNextStepWithCompletionHandler(completionHandler: (shouldGoToNextStep: Bool) -> Void) {
        // Update the data model before sending the user's information to the server.
        model.wantsNewsletter = submitStepViewController.currentWantsNewsletter
        
        submitStepViewController.isRegisteringUser = true
        registerUserWithCompletionHandler { success in
            self.submitStepViewController.isRegisteringUser = false
            
            if success {
                self.showSuccessAlertWithCompletionHandler {
                    completionHandler(shouldGoToNextStep: true)
                }
            }
            else {
                self.showFailureAlertWithCompletionHandler {
                    completionHandler(shouldGoToNextStep: false)
                }
            }
        }
    }
    
    func doWorkBeforeWizardGoesToPreviousStepWithCompletionHandler(completionHandler: (shouldGoToPreviousStep: Bool) -> Void) {
        model.wantsNewsletter = submitStepViewController.currentWantsNewsletter
        completionHandler(shouldGoToPreviousStep: true)
    }
}



// MARK: - Private methods

private extension SubmitWizardStep {

    func registerUserWithCompletionHandler(completionHandler: (success: Bool) -> Void) {
        guard let username = model.username, password = model.password else {
            assertionFailure("Should not be registering a user without a username and password.")
            completionHandler(success: false)
            return
        }
        
        SignUpService.register(
            username,
            password: password,
            wantsNewsletter: model.wantsNewsletter,
            completionHandler: completionHandler)
    }
    
    func showSuccessAlertWithCompletionHandler(completionHandler: Void -> Void) {
        showAlertWithTitle("Welcome!", message: "Thanks for signing up, \(model.username!).", completionHandler: completionHandler)
    }
    
    func showFailureAlertWithCompletionHandler(completionHandler: Void -> Void) {
        showAlertWithTitle("Sorry", message: "Something went wrong, please try again later.", completionHandler: completionHandler)
    }
    
    func showAlertWithTitle(title: String, message: String, completionHandler: Void -> Void) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { _ in
            alert.dismissViewControllerAnimated(false, completion: nil)
            completionHandler()
        }))
        
        submitStepViewController.showViewController(alert, sender: submitStepViewController)
    }
}

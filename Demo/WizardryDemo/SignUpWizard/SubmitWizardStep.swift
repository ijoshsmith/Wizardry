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
    
    fileprivate let model: SignUpWizardModel
    fileprivate let submitStepViewController: SubmitStepViewController
    
    init(model: SignUpWizardModel) {
        self.model = model
        
        let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
        submitStepViewController = (storyboard.instantiateViewController(withIdentifier: "submit") as! SubmitStepViewController)
        submitStepViewController.initialWantsNewsletter = model.wantsNewsletter
    }
}



// MARK: - WizardStep conformance

extension SubmitWizardStep: WizardStep {
    
    var viewController: UIViewController {
        return submitStepViewController
    }
    
    func doWorkBeforeWizardGoesToNextStepWithCompletionHandler(_ completionHandler: @escaping (_ shouldGoToNextStep: Bool) -> Void) {
        // Update the data model before sending the user's information to the server.
        model.wantsNewsletter = submitStepViewController.currentWantsNewsletter
        
        submitStepViewController.isRegisteringUser = true
        registerUserWithCompletionHandler { success in
            self.submitStepViewController.isRegisteringUser = false
            
            if success {
                self.showSuccessAlertWithCompletionHandler {
                    completionHandler(true)
                }
            }
            else {
                self.showFailureAlertWithCompletionHandler {
                    completionHandler(false)
                }
            }
        }
    }
    
    func doWorkBeforeWizardGoesToPreviousStepWithCompletionHandler(_ completionHandler: (_ shouldGoToPreviousStep: Bool) -> Void) {
        model.wantsNewsletter = submitStepViewController.currentWantsNewsletter
        completionHandler(true)
    }
}



// MARK: - Private methods

private extension SubmitWizardStep {

    func registerUserWithCompletionHandler(_ completionHandler: @escaping (_ success: Bool) -> Void) {
        guard let username = model.username, let password = model.password else {
            assertionFailure("Should not be registering a user without a username and password.")
            completionHandler(false)
            return
        }
        
        SignUpService.register(
            username,
            password: password,
            wantsNewsletter: model.wantsNewsletter,
            completionHandler: completionHandler)
    }
    
    func showSuccessAlertWithCompletionHandler(_ completionHandler: @escaping (Void) -> Void) {
        showAlertWithTitle("Welcome!", message: "Thanks for signing up, \(model.username!).", completionHandler: completionHandler)
    }
    
    func showFailureAlertWithCompletionHandler(_ completionHandler: @escaping (Void) -> Void) {
        showAlertWithTitle("Sorry", message: "Something went wrong, please try again later.", completionHandler: completionHandler)
    }
    
    func showAlertWithTitle(_ title: String, message: String, completionHandler: @escaping (Void) -> Void) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            alert.dismiss(animated: false, completion: nil)
            completionHandler()
        }))
        
        submitStepViewController.show(alert, sender: submitStepViewController)
    }
}

//
//  PasswordWizardStep.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/4/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit
import Wizardry

/// The second step in the Sign Up Wizard, where the new user's password is entered.
final class PasswordWizardStep {
    
    private let model: SignUpWizardModel
    private let passwordStepViewController: PasswordStepViewController
    
    init(model: SignUpWizardModel) {
        self.model = model
        
        let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
        passwordStepViewController = (storyboard.instantiateViewControllerWithIdentifier("password") as! PasswordStepViewController)
        passwordStepViewController.initialPassword = model.password
    }
}



// MARK: - WizardStep conformance

extension PasswordWizardStep: WizardStep {
    
    var viewController: UIViewController {
        return passwordStepViewController
    }
    
    func doWorkBeforeWizardGoesToNextStepWithCompletionHandler(completionHandler: (shouldGoToNextStep: Bool) -> Void) {
        if let password = passwordStepViewController.currentPassword where isValidPassword(password) {
            model.password = password
            completionHandler(shouldGoToNextStep: true)
        }
        else {
            self.passwordStepViewController.eraseCurrentPassword()
            completionHandler(shouldGoToNextStep: false)
        }
    }
    
    func doWorkBeforeWizardGoesToPreviousStepWithCompletionHandler(completionHandler: (shouldGoToPreviousStep: Bool) -> Void) {
        model.password = passwordStepViewController.currentPassword
        completionHandler(shouldGoToPreviousStep: true)
    }
}



// MARK: - Private methods

private extension PasswordWizardStep {

    func isValidPassword(password: String) -> Bool {
        return password.characters.count >= 8
    }
}

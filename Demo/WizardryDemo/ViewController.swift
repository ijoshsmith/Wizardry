//
//  ViewController.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/2/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// The view controller first seen after the app launches.
final class ViewController: UIViewController {
    
    @IBAction func handleShowSignUpWizardButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "SignUpWizard", bundle: nil)
        let signUpWizardVC = storyboard.instantiateInitialViewController() as! SignUpWizardViewController
        let model = SignUpWizardModel()
        let dataSource = SignUpWizardDataSource(model: model)
        
        signUpWizardVC.configureWith(dataSource, completionHandler: { [weak self] (canceled: Bool) in
            print("Completed sign up wizard. canceled = \(canceled)")
            self?.dismissViewControllerAnimated(true, completion: nil)
            })
    
        presentViewController(signUpWizardVC, animated: true, completion: nil)
    }
}

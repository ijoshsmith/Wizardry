//
//  SignUpWizardViewController.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/2/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit
import Wizardry

/// A wizard that allows a new user to sign up to use an app.
final class SignUpWizardViewController: WizardViewController {
    
    /*
     NOTE:
     The Back and Next bar button items are connected in the SignUpWizard
     storyboard to action methods defined in WizardViewController.
     */
    
    @IBOutlet fileprivate weak var backButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var contentView: UIView!
    @IBOutlet fileprivate weak var navigationBar: UINavigationBar!
    @IBOutlet fileprivate var nextButtonItem: UIBarButtonItem! // Not weak, because it must be retained while hidden.
    
    fileprivate var currentStepViewController: UIViewController? {
        willSet {
            if let currentStepViewController = currentStepViewController {
                removeChildWizardStepViewController(currentStepViewController)
            }
        }
    }
    
    
    
    // MARK: - Navigation API overrides
    
    override func navigateToInitial(wizardStep: WizardStep) {
        updateNavigationBarFor(WizardStepPlacement.initial)
        addChildWizardStepViewController(wizardStep.viewController)
        currentStepViewController = wizardStep.viewController
    }
    
    override func navigateToNext(wizardStep: WizardStep, placement: WizardStepPlacement) {
        updateNavigationBarFor(placement)
        slideIn(wizardStep.viewController, fromTheRight: true)
    }
    
    override func navigateToPrevious(wizardStep: WizardStep, placement: WizardStepPlacement) {
        updateNavigationBarFor(placement)
        slideIn(wizardStep.viewController, fromTheRight: false)
    }
}



// MARK: - Private methods

private extension SignUpWizardViewController {
 
    func addChildWizardStepViewController(_ viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.view.frame = contentView.bounds
        
        addChildViewController(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    func removeChildWizardStepViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func slideIn(_ stepViewController: UIViewController, fromTheRight: Bool) {
        // In case the current view controller is showing the keyboard, take it out of edit mode.
        currentStepViewController?.view.endEditing(true)
        
        addChildWizardStepViewController(stepViewController)
        
        let
        stepView      = stepViewController.view,
        centerOfView  = stepView?.center,
        leftOfCenter  = CGPoint(x: (centerOfView?.x)! * -3, y: (centerOfView?.y)!),
        rightOfCenter = CGPoint(x: (centerOfView?.x)! * +3, y: (centerOfView?.y)!),
        introCenter   = fromTheRight ? rightOfCenter : leftOfCenter,
        outroCenter   = fromTheRight ? leftOfCenter  : rightOfCenter
        
        stepView?.center = introCenter
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                stepView?.center = centerOfView!
                self.currentStepViewController?.view.center = outroCenter
            },
            completion: { _ in
                self.currentStepViewController = stepViewController
                self.isNavigating = false
        })
        isNavigating = true
    }
    
    func updateNavigationBarFor(_ placement: WizardStepPlacement) {
        let navItem = UINavigationItem(title: "Sign Up")
        backButtonItem.title = (placement == .initial) ? "Cancel" : "Back"
        navItem.leftBarButtonItem = backButtonItem
        navItem.rightBarButtonItem = (placement != .final) ? nextButtonItem : nil
        navigationBar.setItems([navItem], animated: false)
    }
}

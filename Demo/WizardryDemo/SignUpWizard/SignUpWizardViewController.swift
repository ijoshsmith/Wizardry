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
    
    @IBOutlet private weak var backButtonItem: UIBarButtonItem!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private var nextButtonItem: UIBarButtonItem! // Not weak, because it must be retained while hidden.
    
    private var currentStepViewController: UIViewController? {
        willSet {
            if let currentStepViewController = currentStepViewController {
                removeChildWizardStepViewController(currentStepViewController)
            }
        }
    }
    
    
    
    // MARK: - Navigation API overrides
    
    override func navigateToInitialWizardStep(wizardStep: WizardStep) {
        updateNavigationBarFor(WizardStepPlacement.Initial)
        addChildWizardStepViewController(wizardStep.viewController)
        currentStepViewController = wizardStep.viewController
    }
    
    override func navigateToNextWizardStep(wizardStep: WizardStep, placement: WizardStepPlacement) {
        updateNavigationBarFor(placement)
        slideIn(wizardStep.viewController, fromTheRight: true)
    }
    
    override func navigateToPreviousWizardStep(wizardStep: WizardStep, placement: WizardStepPlacement) {
        updateNavigationBarFor(placement)
        slideIn(wizardStep.viewController, fromTheRight: false)
    }
}



// MARK: - Private methods

private extension SignUpWizardViewController {
 
    func addChildWizardStepViewController(viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.view.frame = contentView.bounds
        
        addChildViewController(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func removeChildWizardStepViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func slideIn(stepViewController: UIViewController, fromTheRight: Bool) {
        // In case the current view controller is showing the keyboard, take it out of edit mode.
        currentStepViewController?.view.endEditing(true)
        
        addChildWizardStepViewController(stepViewController)
        
        let
        stepView      = stepViewController.view,
        centerOfView  = stepView.center,
        leftOfCenter  = CGPoint(x: centerOfView.x * -3, y: centerOfView.y),
        rightOfCenter = CGPoint(x: centerOfView.x * +3, y: centerOfView.y),
        introCenter   = fromTheRight ? rightOfCenter : leftOfCenter,
        outroCenter   = fromTheRight ? leftOfCenter  : rightOfCenter
        
        stepView.center = introCenter
        UIView.animateWithDuration(
            0.7,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                stepView.center = centerOfView
                self.currentStepViewController?.view.center = outroCenter
            },
            completion: { _ in
                self.currentStepViewController = stepViewController
                self.isNavigating = false
        })
        isNavigating = true
    }
    
    func updateNavigationBarFor(placement: WizardStepPlacement) {
        let navItem = UINavigationItem(title: "Sign Up")
        backButtonItem.title = (placement == .Initial) ? "Cancel" : "Back"
        navItem.leftBarButtonItem = backButtonItem
        navItem.rightBarButtonItem = (placement != .Final) ? nextButtonItem : nil
        navigationBar.setItems([navItem], animated: false)
    }
}

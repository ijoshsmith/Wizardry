//
//  WizardStep.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/1/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// Describes an object that represents one of several screens shown by a wizard.
public protocol WizardStep {
    
    /// Returns a view controller that displays this step's user interface.
    var viewController: UIViewController { get }
    
    /// Invoked when the user requests a transition to the next wizard step.
    /// The completion handler should be invoked when ready to transition, or to cancel the transition.
    func doWorkBeforeWizardGoesToNextStepWithCompletionHandler(completionHandler: @escaping (_ shouldGoToNextStep: Bool) -> Void)
    
    /// Invoked when the user requests a transition to the previous wizard step.
    /// The completion handler should be invoked when ready to transition, or to cancel the transition.
    func doWorkBeforeWizardGoesToPreviousStepWithCompletionHandler(completionHandler: (_ shouldGoToPreviousStep: Bool) -> Void)
}

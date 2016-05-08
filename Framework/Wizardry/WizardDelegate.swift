//
//  WizardDelegate.swift
//  Wizardry
//
//  Created by Joshua Smith on 4/30/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/// Describes an object that observes events that occur when the user interacts with a wizard.
public protocol WizardDelegate: class {
    
    /// Invoked when the user navigates back from the initial wizard step.
    func wizardDidCancel(wizard: Wizard)
    
    /// Invoked when the user completes the last step of the wizard.
    func wizardDidFinish(wizard: Wizard)

    /// Invoked after the wizard transitions to its initial step for the first time.
    func wizard(wizard: Wizard, didGoToInitialWizardStep wizardStep: WizardStep)
    
    /// Invoked after the wizard transitions to the next step.
    func wizard(wizard: Wizard, didGoToNextWizardStep wizardStep: WizardStep, placement: WizardStepPlacement)
    
    /// Invoked after the wizard transitions to the prior step.
    func wizard(wizard: Wizard, didGoToPreviousWizardStep wizardStep: WizardStep, placement: WizardStepPlacement)
}

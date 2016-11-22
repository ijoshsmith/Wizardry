//
//  WizardDataSource.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/1/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/// Describes an object capable of providing steps to a wizard.
public protocol WizardDataSource {
    
    /// Returns the step to which a wizard should initially transition.
    var initialWizardStep: WizardStep { get }
    
    /// Returns the relative position of the specified wizard step.
    func placementOf(_ wizardStep: WizardStep) -> WizardStepPlacement
    
    /// Returns the wizard step following the specified step, if one exists.
    func wizardStepAfter(_ wizardStep: WizardStep) -> WizardStep?
    
    /// Returns the wizard step preceding the specified step, if one exists.
    func wizardStepBefore(_ wizardStep: WizardStep) -> WizardStep?
}

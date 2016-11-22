//
//  WizardStepPlacement.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/6/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

/// Indicates the relative position of a wizard step within a series of steps.
public enum WizardStepPlacement {
    
    /// The first step displayed by a wizard.
    case initial
    
    /// A step between the initial and final wizard steps.
    case intermediate
    
    /// The last step displayed by a wizard.
    case final
}

//
//  SignUpWizardDataSource.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/2/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit
import Wizardry

/// Creates the wizard steps managed by the Sign Up Wizard. 
final class SignUpWizardDataSource {
    
    fileprivate let model: SignUpWizardModel
    
    init(model: SignUpWizardModel) {
        self.model = model
    }
}



// MARK: - WizardDataSource conformance

extension SignUpWizardDataSource: WizardDataSource {
    
    var initialWizardStep: WizardStep {
        return UsernameWizardStep(model: model)
    }
    
    func placementOf(wizardStep: WizardStep) -> WizardStepPlacement {
        switch wizardStep {
        case is UsernameWizardStep: return .initial
        case is PasswordWizardStep: return .intermediate
        default:
            assert(wizardStep is SubmitWizardStep, "Unsupported: \(wizardStep)")
            return .final
        }
    }
    
    func wizardStepAfter(wizardStep: WizardStep) -> WizardStep? {
        switch wizardStep {
        case is UsernameWizardStep: return PasswordWizardStep(model: model)
        case is PasswordWizardStep: return SubmitWizardStep(model: model)
        default:
            assert(wizardStep is SubmitWizardStep, "Unsupported: \(wizardStep)")
            return nil
        }
    }
    
    func wizardStepBefore(wizardStep: WizardStep) -> WizardStep? {
        switch wizardStep {
        case is UsernameWizardStep: return nil
        case is PasswordWizardStep: return UsernameWizardStep(model: model)
        default:
            assert(wizardStep is SubmitWizardStep, "Unsupported: \(wizardStep)")
            return PasswordWizardStep(model: model)
        }
    }
}

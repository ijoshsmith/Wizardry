//
//  WizardViewController.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/1/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// A view controller that contains a series of wizard steps managed by a `Wizard` object.
/// This view controller does not have a default view, but provides various methods needed
/// to integrate with your custom wizard view. Subclasses must override three 'navigateTo'
/// methods to transition between wizard steps, according to your app's UI layout/design.
open class WizardViewController: UIViewController {
    
    /// Returns the `Wizard` that manages this view controller's wizard steps.
    open fileprivate(set) var wizard: Wizard?
    
    fileprivate var completionHandler: CompletionHandler?
    
    
    
    // MARK: - Configuration
    
    /// Signature of a callback to invoke when the wizard is canceled or finished by the user.
    public typealias CompletionHandler = (_ canceled: Bool) -> Void
    
    /// Provides this view controller with a data source with which to create a `Wizard` object,
    /// and a completion handler to invoke when the user has canceled or finished using it.
    open func configureWith(_ dataSource: WizardDataSource, completionHandler: @escaping CompletionHandler) {
        assert(wizard == nil, "The wizard view controller can only be configured once.")
        
        self.completionHandler = completionHandler

        wizard = Wizard(dataSource: dataSource, delegate: self)
        if isViewLoaded {
            wizard!.goToInitialStep()
        }
    }
    
    
    
    // MARK: - View lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wizard = wizard, wizard.currentStep == nil {
            wizard.goToInitialStep()
        }
    }
    
    
    
    // MARK: - Navigation API for subclasses
    
    /// Set this to `true` while an animated navigation transition is occurring.
    /// This avoids having the user start another transition before the current transition finishes.
    open var isNavigating: Bool = false
    
    /// Subclasses must override this method to display the initial wizard step. Do not call the super implementation.
    open func navigateToInitialWizardStep(_ wizardStep: WizardStep) {
        assertionFailure("\(Mirror(reflecting: self).subjectType) does not properly override \(#function)")
    }
    
    /// Subclasses must override this method to display the next wizard step. Do not call the super implementation.
    open func navigateToNextWizardStep(_ wizardStep: WizardStep, placement: WizardStepPlacement) {
        assertionFailure("\(Mirror(reflecting: self).subjectType) does not properly override \(#function)")
    }
    
    /// Subclasses must override this method to display the previous wizard step. Do not call the super implementation.
    open func navigateToPreviousWizardStep(_ wizardStep: WizardStep, placement: WizardStepPlacement) {
        assertionFailure("\(Mirror(reflecting: self).subjectType) does not properly override \(#function)")
    }
}



// MARK: - Action methods

public extension WizardViewController {
    
    /// Action method that handles when the user wants to navigate to the next wizard step.
    @IBAction public func handleGoToNextStep(_ sender: AnyObject) {
        if isNavigating == false {
            wizard?.goToNextStep()
        }
    }
    
    /// Action method that handles when the user wants to navigate to the previous wizard step.
    @IBAction public func handleGoToPreviousStep(_ sender: AnyObject) {
        if isNavigating == false {
            wizard?.goToPreviousStep()
        }
    }
    
    /// Action method that handles when the user wants to stop using the wizard without completing all of its steps.
    @IBAction public func handleWizardCanceled(_ sender: AnyObject) {
        invokeCompletionHandler(canceled: true)
    }
}



// MARK: - WizardDelegate conformance

extension WizardViewController: WizardDelegate {
    
    public func wizardDidCancel(_ wizard: Wizard) {
        invokeCompletionHandler(canceled: true)
    }
    
    public func wizardDidFinish(_ wizard: Wizard) {
        invokeCompletionHandler(canceled: false)
    }

    public func wizard(_ wizard: Wizard, didGoToInitialWizardStep wizardStep: WizardStep) {
        navigateToInitialWizardStep(wizardStep)
    }
    
    public func wizard(_ wizard: Wizard, didGoToNextWizardStep wizardStep: WizardStep, placement: WizardStepPlacement) {
        navigateToNextWizardStep(wizardStep, placement: placement)
    }
    
    public func wizard(_ wizard: Wizard, didGoToPreviousWizardStep wizardStep: WizardStep, placement: WizardStepPlacement) {
        navigateToPreviousWizardStep(wizardStep, placement: placement)
    }
}



// MARK: - Private methods

private extension WizardViewController {
    
    func invokeCompletionHandler(canceled: Bool) {
        if let completionHandler = completionHandler {
            completionHandler(canceled)
            self.completionHandler = nil
        }
    }
}

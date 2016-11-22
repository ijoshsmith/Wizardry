//
//  WizardViewControllerTests.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/1/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

class WizardViewControllerTests: XCTestCase {
    
    // Subclass the class under test to record information about calls made to its abstract interface.
    class TestWizardViewController: WizardViewController {
        
        var navigateToInitialWizardStep_callCount = 0
        var navigateToInitialWizardStep_wizardStep: WizardStep?
        override func navigateToInitial(wizardStep: WizardStep) {
            navigateToInitialWizardStep_callCount += 1
            navigateToInitialWizardStep_wizardStep = wizardStep
        }
        
        var navigateToNextWizardStep_callCount = 0
        var navigateToNextWizardStep_wizardStep: WizardStep?
        var navigateToNextWizardStep_placement: WizardStepPlacement?
        override func navigateToNext(wizardStep: WizardStep, placement: WizardStepPlacement) {
            navigateToNextWizardStep_callCount += 1
            navigateToNextWizardStep_wizardStep = wizardStep
            navigateToNextWizardStep_placement = placement
        }
        
        var navigateToPreviousWizardStep_callCount = 0
        var navigateToPreviousWizardStep_wizardStep: WizardStep?
        var navigateToPreviousWizardStep_placement: WizardStepPlacement?
        override func navigateToPrevious(wizardStep: WizardStep, placement: WizardStepPlacement) {
            navigateToPreviousWizardStep_callCount += 1
            navigateToPreviousWizardStep_wizardStep = wizardStep
            navigateToPreviousWizardStep_placement = placement
        }
    }
    
    // This arbitrary object is used as the `sender` parameter passed to actions methods.
    private let fakeSender = NSObject()
    
    // The wizard view controller won't navigate to the initial step until the its view is loaded.
    private func forceTransitionToInitialStep(wizardVC: WizardViewController) {
        let _ = wizardVC.view
    }
    
    
    // MARK: - Finishing
    
    func test_allStepsFinished() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        wizardVC = TestWizardViewController()
        
        let notCanceledExpectation = expectation(description: "not canceled")
        wizardVC.configureWith(dataSource) { (canceled: Bool) in
            if canceled == false {
                notCanceledExpectation.fulfill()
            }
        }
        
        forceTransitionToInitialStep(wizardVC: wizardVC)
        
        let wizard = wizardVC.wizard!
        XCTAssert(wizard.currentStep! == stepA)
        
        wizardVC.handleGoToNextStep(fakeSender)
        XCTAssert(wizard.currentStep! == stepB)
        
        wizardVC.handleGoToNextStep(fakeSender)
        XCTAssertNil(wizard.currentStep)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    
    
    // MARK: - Canceling
    
    func test_canceledByGoingBackFromInitialStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        wizardVC = TestWizardViewController()
        
        let canceledExpectation = expectation(description: "canceled")
        wizardVC.configureWith(dataSource) { (canceled: Bool) in
            if canceled {
                canceledExpectation.fulfill()
            }
        }
        
        forceTransitionToInitialStep(wizardVC: wizardVC)
        
        // Going back a step from the initial step causes the wizard to be canceled.
        wizardVC.handleGoToPreviousStep(fakeSender)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func test_explicitlyCanceled() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        wizardVC = TestWizardViewController()
        
        let canceledExpectation = expectation(description: "canceled")
        wizardVC.configureWith(dataSource) { (canceled: Bool) in
            if canceled {
                canceledExpectation.fulfill()
            }
        }
        
        forceTransitionToInitialStep(wizardVC: wizardVC)
        
        // Simulate tapping a 'Cancel' button in the UI.
        wizardVC.handleWizardCanceled(fakeSender)
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    
    
    // MARK: - Navigating
    
    func test_navigateToInitialWizardStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        wizardVC = TestWizardViewController()
        
        wizardVC.configureWith(dataSource) { _ in
            XCTFail("Unexpected completion handler invocation.")
        }
        
        forceTransitionToInitialStep(wizardVC: wizardVC)
        
        // Make sure that configuring the wizard view controller causes it to go to the initial step.
        XCTAssert(wizardVC.navigateToInitialWizardStep_callCount == 1)
        XCTAssert(wizardVC.navigateToInitialWizardStep_wizardStep! == stepA)
    }
    
    func test_navigateToNextWizardStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        wizardVC = TestWizardViewController()
        
        wizardVC.configureWith(dataSource) { _ in
            XCTFail("Unexpected completion handler invocation.")
        }
        
        forceTransitionToInitialStep(wizardVC: wizardVC)
        
        // Simulate a 'Next' button in the UI being tapped.
        wizardVC.handleGoToNextStep(fakeSender)
        
        // Make sure the wizard view controller is navigating to the correct next step.
        XCTAssert(wizardVC.navigateToNextWizardStep_callCount == 1)
        XCTAssert(wizardVC.navigateToNextWizardStep_wizardStep! == stepB)
        XCTAssert(wizardVC.navigateToNextWizardStep_placement! == .final)
    }
    
    func test_navigateToPreviousWizardStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        wizardVC = TestWizardViewController()
        
        wizardVC.configureWith(dataSource) { _ in
            XCTFail("Unexpected completion handler invocation.")
        }
        
        forceTransitionToInitialStep(wizardVC: wizardVC)
        
        // Simulate a 'Next' button in the UI being tapped.
        wizardVC.handleGoToNextStep(fakeSender)
        
        // Simulate a 'Back' button in the UI being tapped.
        wizardVC.handleGoToPreviousStep(fakeSender)
        
        // Make sure the wizard view controller is navigating to the correct previous step.
        XCTAssert(wizardVC.navigateToPreviousWizardStep_callCount == 1)
        XCTAssert(wizardVC.navigateToPreviousWizardStep_wizardStep! == stepA)
        XCTAssert(wizardVC.navigateToPreviousWizardStep_placement! == .initial)
    }
}

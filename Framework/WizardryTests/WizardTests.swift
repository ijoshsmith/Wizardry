//
//  WizardTests.swift
//  WizardryTests
//
//  Created by Joshua Smith on 4/30/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

class WizardTests: XCTestCase {

    // MARK: - goToInitialStep
    
    func test_goToInitialStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: .WizardDidGoToInitialWizardStep),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        
        // The wizard transitions from no step to step A.
        XCTAssert(delegate.wizardDidGoToInitialWizardStep_callCount == 1)
        XCTAssert(delegate.wizardDidGoToInitialWizardStep_wizardStep! == stepA)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    
    
    // MARK: - goToNextStep
    
    func test_goToNextStep_thereIsAnotherStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidGoToNextWizardStep]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToNextStep()
        
        // The wizard transitions from step A to step B.
        XCTAssert(delegate.wizardDidGoToNextWizardStep_callCount == 1)
        XCTAssert(delegate.wizardDidGoToNextWizardStep_wizardStep! == stepB)
        XCTAssert(delegate.wizardDidGoToNextWizardStep_placement! == .final)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    func test_goToNextStep_hasIntermediateStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        stepC = MockStep(name: "C"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB, stepC]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidGoToNextWizardStep]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToNextStep()
        
        // The wizard transitions from step A to step B, which is an intermediate step (because it's between A and C).
        XCTAssert(delegate.wizardDidGoToNextWizardStep_placement! == .intermediate)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    func test_goToNextStep_thereIsOnlyOneStep_wizardFinishes() {
        let
        theOnlyStep = MockStep(name: "A"),
        dataSource = MockDataSource(mockSteps: [theOnlyStep]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidFinish]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToNextStep()
        
        // The wizard finishes because it cannot transition to another step.
        XCTAssert(delegate.wizardDidFinish_callCount == 1)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    func test_goToNextStep_isOnLastStep_wizardFinishes() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidGoToNextWizardStep, .WizardDidFinish]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToNextStep()
        wizard.goToNextStep()
        
        // The wizard transitions to step B the first time it was told to go to the next step.
        XCTAssert(delegate.wizardDidGoToNextWizardStep_callCount == 1)
        XCTAssert(delegate.wizardDidGoToNextWizardStep_wizardStep! == stepB)
        
        // The wizard finishes because it cannot transition to another step after step B.
        XCTAssert(delegate.wizardDidFinish_callCount == 1)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    
    
    // MARK: - goToPreviousStep
    
    func test_goToPreviousStep_isOnInitialStep_wizardCancels() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidCancel]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToPreviousStep()
        
        // The wizard cancels because it cannot transition to a step before the initial step.
        XCTAssert(delegate.wizardDidCancel_callCount == 1)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    func test_goToPreviousStep_isOnSecondStep_wizardGoesBackToInitialStep() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidGoToNextWizardStep, .WizardDidGoToPreviousWizardStep]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToNextStep()
        wizard.goToPreviousStep()
        
        // The wizard transitions from step B to step A.
        XCTAssert(delegate.wizardDidGoToPreviousWizardStep_callCount == 1)
        XCTAssert(delegate.wizardDidGoToPreviousWizardStep_wizardStep! == stepA)
        XCTAssert(delegate.wizardDidGoToPreviousWizardStep_placement! == .initial)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    
    
    // MARK: - Transition cancellation
    
    func test_goToNextStep_currentStepCancelsTransition() {
        let
        stepA = MockStep(name: "A", shouldGoToNextStep: false),
        dataSource = MockDataSource(mockSteps: [stepA]),
        delegate = MockDelegate(expectedMethods: .WizardDidGoToInitialWizardStep),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToNextStep()
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    func test_goToPreviousStep_currentStepCancelsTransition() {
        let
        stepA = MockStep(name: "A", shouldGoToPreviousStep: false),
        dataSource = MockDataSource(mockSteps: [stepA]),
        delegate = MockDelegate(expectedMethods: .WizardDidGoToInitialWizardStep),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()
        wizard.goToPreviousStep()
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    
    
    // MARK: - Non-overlapping transitions
    
    func test_goToNextStep_calledAgainBeforeInvokingCompletionHandler() {
        let
        stepA = MockStep(name: "A", shouldInvokeCompletionHandler: false),
        stepB = MockStep(name: "B"),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: .WizardDidGoToInitialWizardStep),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep() // Transition to step A
        wizard.goToNextStep()    // Step A does not invoke its completion handler…
        wizard.goToNextStep()    // This call is ignored because a transition is in-progress.
        
        // The wizard never transitioned from step A to step B because the completion handler wasn't invoked.
        XCTAssert(wizard.currentStep! == stepA)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
    
    func test_goToPreviousStep_calledAgainBeforeInvokingCompletionHandler() {
        let
        stepA = MockStep(name: "A"),
        stepB = MockStep(name: "B", shouldInvokeCompletionHandler: false),
        dataSource = MockDataSource(mockSteps: [stepA, stepB]),
        delegate = MockDelegate(expectedMethods: [.WizardDidGoToInitialWizardStep, .WizardDidGoToNextWizardStep]),
        wizard = Wizard(dataSource: dataSource, delegate: delegate)
        
        wizard.goToInitialStep()  // Transition to step A
        wizard.goToNextStep()     // Transition to step B
        wizard.goToPreviousStep() // Step B does not invoke its completion handler…   
        wizard.goToPreviousStep() // This call is ignored because a transition is in-progress.
        
        // The wizard never transitioned from step B to step A because the completion handler wasn't invoked.
        XCTAssert(wizard.currentStep! == stepB)
        
        XCTAssert(delegate.unexpectedMethodsCalled.isEmpty)
    }
}

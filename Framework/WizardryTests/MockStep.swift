//
//  MockStep.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/1/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

final class MockStep: WizardStep {
    
    private let name: String
    private let shouldGoToNextStep: Bool
    private let shouldGoToPreviousStep: Bool
    private let shouldInvokeCompletionHandler: Bool
    
    init(_ name: String, shouldGoToNextStep: Bool = true, shouldGoToPreviousStep: Bool = true, shouldInvokeCompletionHandler: Bool = true) {
        self.name = name
        self.shouldGoToNextStep = shouldGoToNextStep
        self.shouldGoToPreviousStep = shouldGoToPreviousStep
        self.shouldInvokeCompletionHandler = shouldInvokeCompletionHandler
    }
    
    var viewController: UIViewController {
        return UIViewController()
    }
    
    func doWorkBeforeWizardGoesToNextStepWithCompletionHandler(completionHandler: (shouldGoToNextStep: Bool) -> Void) {
        if shouldInvokeCompletionHandler {
            completionHandler(shouldGoToNextStep: shouldGoToNextStep)
        }
    }
    
    func doWorkBeforeWizardGoesToPreviousStepWithCompletionHandler(completionHandler: (shouldGoToPreviousStep: Bool) -> Void) {
        if shouldInvokeCompletionHandler {
            completionHandler(shouldGoToPreviousStep: shouldGoToPreviousStep)
        }
    }
}

extension MockStep: CustomDebugStringConvertible {
    var debugDescription: String { return "MockStep \(name)" }
}

extension MockStep: Equatable {}

func == (step1: MockStep, step2: MockStep) -> Bool {
    return step1.name == step2.name
}

func == (step1: WizardStep, step2: MockStep) -> Bool {
    return step1 is MockStep && (step1 as! MockStep) == step2
}

func == (step1: MockStep, step2: WizardStep) -> Bool {
    return step2 is MockStep && step1 == (step2 as! MockStep)
}

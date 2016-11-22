//
//  MockDataSource.swift
//  Wizardry
//
//  Created by Joshua Smith on 5/1/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

final class MockDataSource: WizardDataSource {
    
    private let mockSteps: [MockStep]
    
    init(mockSteps: [MockStep]) {
        self.mockSteps = mockSteps
    }
    
    var initialWizardStep: WizardStep {
        return mockSteps.first!
    }
    
    func placementOf(wizardStep: WizardStep) -> WizardStepPlacement {
        switch indexOf(wizardStep: wizardStep) {
        case 0:                   return .initial
        case mockSteps.count - 1: return .final
        default:                  return .intermediate
        }
    }
    
    func wizardStepAfter(wizardStep: WizardStep) -> WizardStep? {
        let index = indexOf(wizardStep: wizardStep) + 1
        return index < mockSteps.count ? mockSteps[index] : nil
    }
    
    func wizardStepBefore(wizardStep: WizardStep) -> WizardStep? {
        let index = indexOf(wizardStep: wizardStep) - 1
        return -1 < index ? mockSteps[index] : nil
    }
    
    private func indexOf(wizardStep: WizardStep) -> Int {
        let index = mockSteps.index { $0 == wizardStep }
        return index!
    }
}

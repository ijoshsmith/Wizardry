//
//  UsernameService.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/4/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/// Pretends to call a service that checks if a username is available. In a real system, this service might put
/// a temporary hold on that username so it is not taken by someone else before this user completes the wizard.
final class UsernameService {
    
    static func checkIfAvailable(_ username: String, completionHandler: @escaping (_ isUsernameAvailable: Bool) -> Void) {
        print("Pretending to check if the username \(username) is available.")
        
        // Consider a username that starts with 'user' to be unavailable.
        let isAvailable = username.lowercased().hasPrefix("user") == false
        
        // Invoke the completion handler after a moment, to simulate network latency.
        let delayTime = DispatchTime.now() + Double(Int64(0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completionHandler(isAvailable)
        }
    }
}

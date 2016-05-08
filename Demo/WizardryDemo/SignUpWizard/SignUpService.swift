//
//  SignUpService.swift
//  WizardryDemo
//
//  Created by Joshua Smith on 5/5/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/// Pretends to call a service to create an account for a new user.
final class SignUpService {
    
    static func register(username: String, password: String, wantsNewsletter: Bool, completionHandler: (success: Bool) -> Void) {
        print("Pretending to register \(username) with the password \(password). Wants newsletter? \(wantsNewsletter)")

        let success = (username != "jerkface") // This username can be used to test the failure path.
        
        // Invoke the completion handler after a moment, to simulate network latency.
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            completionHandler(success: success)
        }
    }
}

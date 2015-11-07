//
//  Functions.swift
//  App_MyLocations
//
//  Created by User on 7/11/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import Foundation
import Dispatch


func afterDelay(seconds: Double, clousure: () ->()){
    
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), clousure)
  
}

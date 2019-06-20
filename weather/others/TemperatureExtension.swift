//
//  TemperatureExtension.swift
//  weather
//
//  Created by Vladimir Psyukalov on 20.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import Foundation

extension Double {
    
    func fullString() -> String {
        return NSString(format: "%@%0.1f \u{00B0}C", self <= 0.0 ? "" : "+", self) as String
    }
    
    func toCelsius() -> Double {
        return (self - 32.0) * 5.0 / 9.0
    }
    
}

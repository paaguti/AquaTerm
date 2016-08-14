//
//  AQTHelpers.swift
//  AquaTerm
//
//  Created by C.W. Betts on 2/26/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import AquaTerm
import AquaTerm.AQTFunctions

//public func AQTEqualColors(c1: AQTColor, _ c2: AQTColor) -> Bool

public func ==(lhs: AQTColor, rhs: AQTColor) -> Bool {
   return AQTEqualColors(lhs, rhs)
}

extension AQTColor: Equatable {
   
}
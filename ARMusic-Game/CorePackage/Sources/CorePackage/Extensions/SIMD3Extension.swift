//
//  File.swift
//  
//
//  Created by Eduardo on 28/07/24.
//

import Foundation
import simd

extension SIMD3 where Scalar == Float {
    
    func distance(from other: SIMD3<Float>) -> Float {
        return simd_distance(self, other)
    }
    
}

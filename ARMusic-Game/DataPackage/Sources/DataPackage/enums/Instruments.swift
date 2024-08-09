//
//  File.swift
//  
//
//  Created by Eduardo on 02/08/24.
//

import Foundation

/**
 Enum representing different musical instruments.
 
 - piano: Represents the piano instrument.
 */
public enum Instruments: String, CaseIterable {
    case piano
    case guitar
}

// Extension to get all cases as an array
extension Instruments {
    static var allCasesArray: [Instruments] {
        return Array(self.allCases)
    }
}

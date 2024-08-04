//
//  File.swift
//  
//
//  Created by Eduardo on 02/08/24.
//

import Foundation

/**
 Enum representing musical notes.
 
 - c: Represents the C note.
 - d: Represents the D note.
 - e: Represents the E note.
 - g: Represents the G note.
 - a: Represents the A note.
 */
public enum Notes: String, CaseIterable {
    case c = "C"
    case d = "D"
    case e = "E"
    case g = "G"
    case a = "A"
}

// Extension to get all cases as an array
extension Notes {
    static var allCasesArray: [Notes] {
        return Array(self.allCases)
    }
}

//
//  File.swift
//
//
//  Created by Eduardo on 23/07/24.
//

import Foundation

import Foundation

enum Instruments: String {
    case piano
    // Add other instruments as needed
}

enum Notes: String {
    case c = "C"
    case d = "D"
    case e = "E"
    case g = "G"
    case a = "A"
}

struct AudioData {
    let instrument: Instruments
    let note: Notes
    
    var fileName: String {
        return "\(instrument.rawValue)_\(note.rawValue).mpeg"
    }
    
    var url: URL? {
        return Bundle.main.url(forResource: fileName, withExtension: nil)
    }
    
    func getURL() -> URL? {
        return self.url
    }
}


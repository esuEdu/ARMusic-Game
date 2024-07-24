//
//  File.swift
//
//
//  Created by Eduardo on 23/07/24.
//

import Foundation


/**
 Enum representing different musical instruments.
 
 - piano: Represents the piano instrument.
 */
public enum Instruments: String {
    case piano
    // Add other instruments as needed
}

/**
 Enum representing musical notes.
 
 - c: Represents the C note.
 - d: Represents the D note.
 - e: Represents the E note.
 - g: Represents the G note.
 - a: Represents the A note.
 */
public enum Notes: String {
    case c = "C"
    case d = "D"
    case e = "E"
    case g = "G"
    case a = "A"
}

/**
 Struct representing audio data for a specific instrument and note.
 */
public struct AudioData {
    
    /// The instrument associated with the audio data.
    let instrument: Instruments

    /// The note associated with the audio data.
    let note: Notes
    
    /// The file name of the audio data based on the instrument and note.
    var fileName: String {
        return "\(instrument.rawValue)_\(note.rawValue)"
    }
    
    /// The URL of the audio file in the main bundle.
    var url: URL? {
        return Bundle.module.url(forResource: fileName, withExtension: "mpeg")
    }
    
    /**
     Returns the URL of the audio file.
     
     - Returns: An optional URL pointing to the audio file in the main bundle.
     */
    func getURL() -> URL? {
        print("Audio file URL: \(String(describing: self.url))")
        return self.url
    }
}


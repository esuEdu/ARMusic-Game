//
//  File.swift
//
//
//  Created by Eduardo on 23/07/24.
//

import Foundation

/**
 Struct representing audio data for a specific instrument and note.
 */
public struct AudioData {
    
    /// The instrument associated with the audio data.
    let instrument: Instruments

    /// The note associated with the audio data.
    let note: Notes
    
    public init(instrument: Instruments, note: Notes) {
        self.instrument = instrument
        self.note = note
    }
    
    /// The file name of the audio data based on the instrument and note.
    var fileName: String {
        return "\(instrument.rawValue)_\(note.rawValue)"
    }
    
    /// The URL of the audio file in the main bundle.
    var url: URL? {
        return Bundle.module.url(forResource: fileName, withExtension: "mp3")
    }
    
    /**
     Returns the URL of the audio file.
     
     - Returns: An optional URL pointing to the audio file in the main bundle.
     */
    public func getURL() -> URL? {
        return self.url
    }
}


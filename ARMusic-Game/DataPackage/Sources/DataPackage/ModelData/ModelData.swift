//
//  File.swift
//  
//
//  Created by Eduardo on 02/08/24.
//

import Foundation

/**
 Struct representing audio data for a specific instrument and note.
 */
public struct ModelData {
    
    /// The instrument associated with the audio data.
    let instrument: Instruments

    
    public init(instrument: Instruments) {
        self.instrument = instrument
    }
    
    /// The file name of the audio data based on the instrument and note.
    public var fileName: String {
        return "\(instrument.rawValue)"
    }
    
    /// The URL of the audio file in the main bundle.
    var url: URL? {
        return Bundle.module.url(forResource: fileName, withExtension: "usdz")
    }
    
    /**
     Returns the URL of the audio file.
     
     - Returns: An optional URL pointing to the audio file in the main bundle.
     */
    public func getURL() -> URL? {
        return self.url
    }
}


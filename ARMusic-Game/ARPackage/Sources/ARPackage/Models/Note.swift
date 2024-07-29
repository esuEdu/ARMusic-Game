//
//  Note.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import Foundation

public struct Note {
    public let name: String
    public let audioFile: String
    
    public init(name: String, audioFile: String) {
        self.name = name
        self.audioFile = audioFile
    }
}

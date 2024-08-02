//
//  Note.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import Foundation
import AudioPackage
import DataPackage

public struct Note: Identifiable {
    public let id = UUID()
    public let name: String
    public let type: Notes
    public let audioFile: String
    
    public init(name: String, audioFile: String, type: Notes) {
        self.name = name
        self.audioFile = audioFile
        self.type = type
    }
}

//
//  Instrument.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import Foundation

public struct Instrument: Identifiable {
    public let id = UUID()
    public let name: String
    public let modelName: String
    public let notes: [Note]
    
    public init(name: String, modelName: String, notes: [Note]) {
        self.name = name
        self.modelName = modelName
        self.notes = notes
    }
}

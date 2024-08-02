//
//  Instrument.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import Foundation

public struct Instrument: Identifiable {
    public var id:UUID
    public let name: String
    public let modelName: String
    public var notes: [Note]
    public var selectedNote: Note?
    public var description:String?
    public var sequence: Set<Int> 
    
    public init(name: String, modelName: String, notes: [Note], sequence: Set<Int>) {
        self.id = UUID()
        self.name = name
        self.modelName = modelName
        self.notes = notes
        self.sequence = sequence
    }
}

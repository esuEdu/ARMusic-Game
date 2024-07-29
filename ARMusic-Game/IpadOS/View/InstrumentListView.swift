//
//  InstrumentListView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import SwiftUI
import ARPackage

struct InstrumentListView: View {
    @ObservedObject var instrumentSystem: InstrumentSystem
    
    let instruments: [Instrument] = [
        Instrument(name: "Piano", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "Piano/Note1"),
            Note(name: "D", audioFile: "Piano/Note2"),
            Note(name: "E", audioFile: "Piano/Note3"),
            Note(name: "F", audioFile: "Piano/Note4"),
            Note(name: "G", audioFile: "Piano/Note5")
        ]),
        Instrument(name: "Guitar", modelName: "guitarra", notes: [
            Note(name: "A", audioFile: "Guitar/Note1"),
            Note(name: "B", audioFile: "Guitar/Note2"),
            Note(name: "C", audioFile: "Guitar/Note3"),
            Note(name: "D", audioFile: "Guitar/Note4"),
            Note(name: "E", audioFile: "Guitar/Note5")
        ])
    ]
    
    var body: some View {
        List {
            ForEach(instruments) { instrument in
                Button(action: {
                    instrumentSystem.addInstrument(instrument)
                }) {
                    Text(instrument.name)
                }
            }
        }
    }
}



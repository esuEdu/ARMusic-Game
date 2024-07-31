//
//  MainHUDView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 29/07/24.
//

import SwiftUI
import ARPackage

struct MainHUDView: View {
    @EnvironmentObject var instrumentSystem: InstrumentSystem
    @State private var selectedNote: Note? = nil
    
    var body: some View {
        ZStack {
            InstrumentListView()
            PauseButtonView()
            // BPMSelectorView()
            // NoteTimeSelectionView()
            
            if let selectedNote = selectedNote, let selectedInstrument = instrumentSystem.selectedInstrument {
                NoteTimeSelectionView(instrument: $instrumentSystem.selectedInstrument)
                    .transition(.move(edge: .bottom))
            }
            
            if let selectedInstrument = instrumentSystem.selectedInstrument {
                SelectMusicalNoteView(selectedNote: $selectedNote, instrument: $instrumentSystem.selectedInstrument) { note in
                    selectedNote = note
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}


#Preview {
    MainHUDView()
}

//
//  MainHUDView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 29/07/24.
//

import SwiftUI
import ARPackage

struct MainHUDView: View {
    @State private var selectedInstrument: Instrument?
    @State private var selectedNote: Note?

    var body: some View {
        ZStack {
            InstrumentListView()
//            PauseButtonView()
//            BPMSelectorView()
//            SelectMusicalNoteView()
//            NoteTimeSelectionView()
        }
    }
}


#Preview {
    MainHUDView()
}

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
    @State private var isExpandedInstrumentList = false

    var body: some View {
        ZStack {
            
            InstrumentListView(isExpanded: $isExpandedInstrumentList)
            
            showView(!isExpandedInstrumentList) {
                PauseButtonView()
            }
            
            // Mostre quando um instrumento for selecionado
            showView(instrumentSystem.selectedInstrument == nil) {
                BPMSelectorView()
            }
            
            // Mostre quando uma nota e um instrumento for selecionado
            showView(selectedNote != nil && instrumentSystem.selectedInstrument != nil) {
                NoteTimeSelectionView(instrument: $instrumentSystem.selectedInstrument)
                    .transition(.move(edge: .bottom))
            }
            
            // Mostre quando uma instrumento for selecionado
            showView(instrumentSystem.selectedInstrument != nil) {
                SelectMusicalNoteView(selectedNote: $selectedNote, instrument: $instrumentSystem.selectedInstrument) { note in
                    selectedNote = note
                }
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func showView<V: View>(_ condition: Bool, @ViewBuilder content: () -> V) -> some View {
        if condition {
            content()
        }
    }
}


#Preview {
    MainHUDView()
}

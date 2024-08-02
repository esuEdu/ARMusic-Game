//
//  MainHUDView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 29/07/24.
//

import SwiftUI
import ARPackage

struct MainHUDView: View {
    @Environment(InstrumentSystem.self) var instrumentSystem: InstrumentSystem
    @State private var selectedNote: Note? = nil
    @State private var isExpandedInstrumentList = false
    
    @State private var isPaused:Bool = false
    @State private var isMuted:Bool = false
    
    var body: some View {
        ZStack {
            
            InstrumentListView(isExpanded: $isExpandedInstrumentList)
            
            showView(!isExpandedInstrumentList) {
                PauseButtonView(isPaused: $isPaused)
            }
            
            // Mostre quando um instrumento for selecionado
            showView(instrumentSystem.selectedEntity == nil) {
                BPMSelectorView()
            }
            
            // Mostre quando uma nota e um instrumento for selecionado
            showView(selectedNote != nil && instrumentSystem.selectedEntity != nil) {
                NoteTimeSelectionView(entity: instrumentSystem.entityBinding)
                    .transition(.move(edge: .bottom))
            }
            
            // Mostre quando uma instrumento for selecionado
            showView(instrumentSystem.selectedEntity != nil) {
                MuteButtonView(isMuted: $isMuted)
                SelectMusicalNoteView(selectedNote: $selectedNote, entity: instrumentSystem.entityBinding) { note in
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

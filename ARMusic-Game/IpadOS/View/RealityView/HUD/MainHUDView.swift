//
//  MainHUDView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 29/07/24.
//

import SwiftUI
import ARPackage

struct MainHUDView: View {
    @Environment(ARViewManager.self) var arViewManager: ARViewManager
    @State private var isExpandedInstrumentList = false
    
    @State private var isPaused:Bool = false
    @State private var isMuted:Bool = false
    
    @State var selectedNote:String? = nil

    var body: some View {
        ZStack {
            switch arViewManager.stateMachine.state {
            case .normal:
                InstrumentListView(isExpanded: $isExpandedInstrumentList)
                showView(!isExpandedInstrumentList) {
                    PauseButtonView(isPaused: $isPaused)
                }
                showView(arViewManager.stateMachine.getEntity() == nil) {
                    BPMSelectorView()
                }
                
            case .editing(let entity):
                showView(selectedNote != nil) {
                    NoteTimeSelectionView()
                        .transition(.move(edge: .bottom))
                }
                showView(arViewManager.stateMachine.getEntity() != nil) {
                    MuteButtonView(isMuted: $isMuted)
                    SelectMusicalNoteView(entity: entity, selectedNote: $selectedNote)
                        .transition(.move(edge: .bottom))
                }
                
            case .dragging:
                // Hide all elements
                EmptyView()
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

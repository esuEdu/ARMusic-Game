//
//  SelectMusicalNoteView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 31/07/24.
//

import SwiftUI
import ARPackage

struct NoteButton: View {
    let note: String
    let action: () -> Void
    let isSystemImage: Bool
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.blue)
                .frame(width: self.screenHeight * 0.087, height: self.screenHeight * 0.087)
                .overlay(
                    Group {
                        if isSystemImage {
                            Image(systemName: note)
                                .foregroundColor(.white)
                                .font(.headline)
                        } else {
                            Text(note)
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                )
        }
    }
}

struct SelectMusicalNoteView: View {
    @Environment(InstrumentSystem.self) var instrumentSystem: InstrumentSystem
    @Binding var entity: InstrumentEntity?
    @State private var showMenu: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            if showMenu {
                ForEach(entity?.instrument.notes ?? []) { note in
                    NoteButton(note: note.name, action: {
                        withAnimation {
                            entity?.instrument.selectedNote = note
                            
                            print("Nota selecionada: \(note.name)")
                            
                            if let updatedEntity = entity {
                                instrumentSystem.setSequence(for: updatedEntity)
                            }
                            
                            showMenu = false
                        }
                    }, isSystemImage: false)
                    .padding(.bottom, 10)
                }
            }
            
            NoteButton(note: showMenu ? "xmark" : (entity?.instrument.selectedNote?.name ?? "music.note"), action: {
                withAnimation {
                    if showMenu {
                        entity?.instrument.selectedNote = nil
                        
                        if let updatedEntity = entity {
                            instrumentSystem.setSequence(for: updatedEntity)
                        }
                    }
                    
                    showMenu.toggle()
                }
            }, isSystemImage: (entity?.instrument.selectedNote == nil) || showMenu)
        }
        .position(x: self.screenWidth * 0.1, y: self.screenHeight * 0.45)
    }
}

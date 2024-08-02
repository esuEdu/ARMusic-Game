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
    @Binding var selectedNote: Note?
    @Binding var entity: InstrumentEntity?
    
    @State private var showMenu: Bool = false

    let onNoteSelected: (Note) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            if showMenu {
                ForEach(entity?.instrument.notes ?? []) { note in
                    NoteButton(note: note.name, action: {
                        withAnimation {
                            selectedNote = note
                            showMenu = false
                            onNoteSelected(note)
                        }
                    }, isSystemImage: false)
                    .padding(.bottom, 10)
                }
            }
            
            NoteButton(note: showMenu ? "xmark" : (selectedNote?.name ?? "music.note"), action: {
                withAnimation {
                    if showMenu {
                        selectedNote = nil
                    }
                    showMenu.toggle()
                }
            }, isSystemImage: (selectedNote == nil) || showMenu)
        }
        .position(x: self.screenWidth * 0.1, y: self.screenHeight * 0.45)
    }
}

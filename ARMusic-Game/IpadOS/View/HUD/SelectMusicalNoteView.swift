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
                .frame(width: 50, height: 50)
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
    @Binding var instrument: Instrument?
    
    @State private var showMenu: Bool = false

    let onNoteSelected: (Note) -> Void
    
    var body: some View {
        VStack {
            if showMenu {
                ForEach(instrument?.notes ?? []) { note in
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
    }
}

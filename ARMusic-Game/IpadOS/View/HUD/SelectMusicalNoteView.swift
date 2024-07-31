//
//  SelectMusicalNoteView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 31/07/24.
//

import SwiftUI

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
    @State private var selectedNote: String? = nil
    @State private var showMenu: Bool = false
    
    let notes = ["A", "B", "C", "D", "E"]
    
    var body: some View {
        VStack {
            if showMenu {
                ForEach(notes, id: \.self) { note in
                    NoteButton(note: note, action: {
                        withAnimation {
                            selectedNote = note
                            showMenu = false
                        }
                    }, isSystemImage: false)
                    .padding(.bottom, 10)
                }
            }
            
            NoteButton(note: showMenu ? "xmark" : (selectedNote == nil ? "music.note" : selectedNote!), action: {
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

#Preview {
    SelectMusicalNoteView()
}

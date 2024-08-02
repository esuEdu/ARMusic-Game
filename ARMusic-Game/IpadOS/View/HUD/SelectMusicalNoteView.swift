//
//  SelectMusicalNoteView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 31/07/24.
//

import SwiftUI
import ARPackage
import RealityKit
import DataPackage

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
    @Binding var entity: Entity?
    @State private var showMenu: Bool = false
    @State var notas = ["C", "D", "E", "A", "B"]
    
    @Binding var selectedNote:String?
    
    var body: some View {
        VStack {
            Spacer()
            if showMenu {
                ForEach(notas, id: \.self) { note in
                    NoteButton(note: note, action: {
                        withAnimation {
                            selectedNote = note
                            if let selectNote = Notes(rawValue: note) {
                                instrumentSystem.changeEntity(for: entity, note: selectNote)
                                print("Nota selecionada: \(note)")
                                
                                showMenu = false
                            }
                        }
                    }, isSystemImage: false)
                    .padding(.bottom, 10)
                }
            }
            
            NoteButton(
                note: showMenu ? "xmark" : (selectedNote != nil ? "music.note" : ""),
                action: {
                    withAnimation {
                        if showMenu {
                            selectedNote = nil
                        }

                        showMenu.toggle()
                    }
                },
                isSystemImage: (selectedNote != nil) || showMenu
            )

        }
        .position(x: self.screenWidth * 0.1, y: self.screenHeight * 0.45)
    }
}

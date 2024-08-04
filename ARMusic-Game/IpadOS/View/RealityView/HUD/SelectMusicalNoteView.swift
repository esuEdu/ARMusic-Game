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
import AudioPackage

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
    @Environment(ARViewManager.self) var arViewManager: ARViewManager
    @State var entity: Entity?
    @State private var showMenu: Bool = false
    @State var notas = Notes.allCases
    
    @Binding var selectedNote: String?
    
    var body: some View {
        VStack {
            Spacer()
            if showMenu {
                ForEach(notas, id: \.self) { note in
                    NoteButton(note: note.rawValue, action: {
                        withAnimation {
                            selectedNote = note.rawValue
                            if let selectNote = Notes(rawValue: note.rawValue) {
                                //add change entity
                                if let instrumentEntity = entity as? InstrumentEntity {
                                    instrumentEntity.changeAudioComponent(note: selectNote)
                                }
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

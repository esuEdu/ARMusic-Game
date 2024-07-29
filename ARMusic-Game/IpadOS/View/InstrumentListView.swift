//
//  InstrumentListView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import SwiftUI
import ARPackage
import ARKit

struct InstrumentListView: View {
    @EnvironmentObject var instrumentSystem: InstrumentSystem
    @State private var isExpanded = false
    @State private var dragOffsets: [Int: CGSize] = [:]
    
    let instruments: [Instrument] = [
        Instrument(name: "Piano", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "Piano/Note1"),
            Note(name: "D", audioFile: "Piano/Note2"),
            Note(name: "E", audioFile: "Piano/Note3"),
            Note(name: "F", audioFile: "Piano/Note4"),
            Note(name: "G", audioFile: "Piano/Note5")
        ]),
        Instrument(name: "Guitar", modelName: "guitarra", notes: [
            Note(name: "A", audioFile: "Guitar/Note1"),
            Note(name: "B", audioFile: "Guitar/Note2"),
            Note(name: "C", audioFile: "Guitar/Note3"),
            Note(name: "D", audioFile: "Guitar/Note4"),
            Note(name: "E", audioFile: "Guitar/Note5")
        ]),
        Instrument(name: "Violão", modelName: "guitarra", notes: [
            Note(name: "A", audioFile: "Guitar/Note1"),
            Note(name: "B", audioFile: "Guitar/Note2"),
            Note(name: "C", audioFile: "Guitar/Note3"),
            Note(name: "D", audioFile: "Guitar/Note4"),
            Note(name: "E", audioFile: "Guitar/Note5")
        ]),
        Instrument(name: "Voz", modelName: "guitarra", notes: [
            Note(name: "A", audioFile: "Guitar/Note1"),
            Note(name: "B", audioFile: "Guitar/Note2"),
            Note(name: "C", audioFile: "Guitar/Note3"),
            Note(name: "D", audioFile: "Guitar/Note4"),
            Note(name: "E", audioFile: "Guitar/Note5")
        ]),
        Instrument(name: "Bateria", modelName: "guitarra", notes: [
            Note(name: "A", audioFile: "Guitar/Note1"),
            Note(name: "B", audioFile: "Guitar/Note2"),
            Note(name: "C", audioFile: "Guitar/Note3"),
            Note(name: "D", audioFile: "Guitar/Note4"),
            Note(name: "E", audioFile: "Guitar/Note5")
        ]),
        Instrument(name: "Baixo", modelName: "guitarra", notes: [
            Note(name: "A", audioFile: "Guitar/Note1"),
            Note(name: "B", audioFile: "Guitar/Note2"),
            Note(name: "C", audioFile: "Guitar/Note3"),
            Note(name: "D", audioFile: "Guitar/Note4"),
            Note(name: "E", audioFile: "Guitar/Note5")
        ])
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "arrowshape.right.circle" : "arrowshape.left.circle")
                        .font(.title)
                }
                .padding(.vertical, 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.trailing, -10)
                
                ZStack(alignment: .leading) {
                    if isExpanded {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(instruments.indices, id: \.self) { index in
                                let instrument = instruments[index]
                                VStack {
                                    Image(instrument.modelName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .onTapGesture {
                                    instrumentSystem.addInstrument(instrument)
                                    isExpanded = false
                                }
                                .offset(dragOffsets[index, default: .zero])
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffsets[index] = value.translation
                                        }
                                        .onEnded { value in
                                            if isDropLocationOutside(bounds: geometry.frame(in: .global), dropLocation: value.location) {
                                                instrumentSystem.addInstrument(instrument)
                                            }
                                            dragOffsets[index] = .zero
                                            withAnimation {
                                                isExpanded = false
                                            }
                                        }
                                )
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.95)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                        )
                        .transition(.move(edge: .trailing))
                    }
                }
                .frame(width: isExpanded ? geometry.size.width * 0.4 : 0, height: geometry.size.height * 0.95)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func isDropLocationOutside(bounds: CGRect, dropLocation: CGPoint) -> Bool {
        return !bounds.contains(dropLocation)
    }
}




#Preview {
    InstrumentListView()
        .environmentObject(InstrumentSystem(arView: nil))
}

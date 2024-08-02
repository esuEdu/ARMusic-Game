//
//  InstrumentListView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import SwiftUI
import ARPackage
import ARKit
import RealityKit

struct InstrumentListView: View {
    @Environment(InstrumentSystem.self) var instrumentSystem: InstrumentSystem
    @Binding var isExpanded:Bool
    @State private var dragOffsets: [Int: CGSize] = [:]
    
    let instruments: [Instrument] = [
        Instrument(name: "Piano", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "", type: .c),
            Note(name: "D", audioFile: "", type: .d),
            Note(name: "E", audioFile: "", type: .e),
            Note(name: "G", audioFile: "", type: .g),
            Note(name: "A", audioFile: "", type: .a)
        ], sequence: []),
        Instrument(name: "Guitarra", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "", type: .c),
            Note(name: "D", audioFile: "", type: .d),
            Note(name: "E", audioFile: "", type: .e),
            Note(name: "G", audioFile: "", type: .g),
            Note(name: "A", audioFile: "", type: .a)
        ], sequence: []),
        Instrument(name: "Bateria", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "", type: .c),
            Note(name: "D", audioFile: "", type: .d),
            Note(name: "E", audioFile: "", type: .e),
            Note(name: "G", audioFile: "", type: .g),
            Note(name: "A", audioFile: "", type: .a)
        ], sequence: []),
        Instrument(name: "Violão", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "", type: .c),
            Note(name: "D", audioFile: "", type: .d),
            Note(name: "E", audioFile: "", type: .e),
            Note(name: "G", audioFile: "", type: .g),
            Note(name: "A", audioFile: "", type: .a)
        ], sequence: []),
        Instrument(name: "Voz", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "", type: .c),
            Note(name: "D", audioFile: "", type: .d),
            Note(name: "E", audioFile: "", type: .e),
            Note(name: "G", audioFile: "", type: .g),
            Note(name: "A", audioFile: "", type: .a)
        ], sequence: []),
        Instrument(name: "Pandeiro", modelName: "guitarra", notes: [
            Note(name: "C", audioFile: "", type: .c),
            Note(name: "D", audioFile: "", type: .d),
            Note(name: "E", audioFile: "", type: .e),
            Note(name: "G", audioFile: "", type: .g),
            Note(name: "A", audioFile: "", type: .a)
        ], sequence: []),
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
    InstrumentListView(isExpanded: Binding.constant(true))
        .environment(InstrumentSystem(arView: nil))
}

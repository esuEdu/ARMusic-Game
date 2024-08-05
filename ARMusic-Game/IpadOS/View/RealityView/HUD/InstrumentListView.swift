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
import DataPackage


struct InstrumentListView: View {
    @Binding var isExpanded: Bool
    @State private var dragOffsets: [Instruments: CGSize] = [:]
    
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    let instruments = Instruments.allCases
    
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
                            ForEach(instruments, id: \.self) { instrument in
                                VStack {
                                    Image(instrument.rawValue)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .onTapGesture {
                                    arViewManager.arView?.loadInstrumentModel(instrument: instrument)
                                    isExpanded = false
                                }
                                .offset(dragOffsets[instrument, default: .zero])
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffsets[instrument] = value.translation
                                        }
                                        .onEnded { value in
                                            if isDropLocationOutside(bounds: geometry.frame(in: .global), dropLocation: value.location) {
                                                arViewManager.arView?.loadInstrumentModel(instrument: instrument)
                                            }
                                            dragOffsets[instrument] = .zero
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

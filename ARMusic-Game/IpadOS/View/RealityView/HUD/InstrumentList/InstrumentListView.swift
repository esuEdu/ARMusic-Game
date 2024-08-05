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
                    Image(systemName: isExpanded ? "chevron.right" : "chevron.left")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, -15)
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    if isExpanded {
                        Text("Personagens")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    ScrollView {
                        
                        if isExpanded {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(instruments, id: \.self) { instrument in
                                    InstrumentCardView(instrumentInfo: InstrumentInfo.get(for: instrument))
                                        .onTapGesture {
                                            arViewManager.loadInstrumentModel(instrument: instrument)
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
                                                        arViewManager.loadInstrumentModel(instrument: instrument)
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
                            .frame(width: geometry.size.width * 0.4)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .transition(.move(edge: .trailing))
                .frame(width: isExpanded ? geometry.size.width * 0.4 :  0)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func isDropLocationOutside(bounds: CGRect, dropLocation: CGPoint) -> Bool {
        return !bounds.contains(dropLocation)
    }
}

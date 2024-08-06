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
    @State private var draggingInstrument: Instruments?
    @State private var currentDragOffset: CGSize = .zero
    
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    let instruments = Instruments.allCases
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Spacer()
                    
                    ExpandButton(isExpanded: $isExpanded)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        HeaderView(isExpanded: isExpanded)
                        
                        ScrollView {
                            if isExpanded {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(instruments, id: \.self) { instrument in
                                        DraggableInstrumentCardView(
                                            instrument: instrument, geometry: geometry,
                                            dragOffsets: $dragOffsets,
                                            draggingInstrument: $draggingInstrument,
                                            currentDragOffset: $currentDragOffset,
                                            isDrop: isDropLocationOutside
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
                    .frame(width: isExpanded ? geometry.size.width * 0.4 : 0)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                    )
                }
                
                if let instrument = draggingInstrument {
                    InstrumentCardDraggingView(
                        instrument: instrument, geometry: geometry,
                        currentDragOffset: $currentDragOffset,
                        isDrop: isDropLocationOutside
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func isDropLocationOutside(bounds: CGRect, dropLocation: CGPoint) -> Bool {
        return !bounds.contains(dropLocation)
    }
}


struct InstrumentCardDraggingView: View {
    let instrument: Instruments
    let geometry:GeometryProxy
    @Binding var currentDragOffset: CGSize
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    let isDrop: (CGRect, CGPoint) -> Bool

    var body: some View {
        InstrumentCardView(instrumentInfo: InstrumentInfo.get(for: instrument))
            .scaleEffect(1.1)
            .offset(currentDragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        currentDragOffset = value.translation
                    }
                    .onEnded { value in
                        currentDragOffset = .zero
                        if isDrop(geometry.frame(in: .global), value.location) {
                            arViewManager.arView?.loadInstrumentModel(instrument: instrument)
                        }
                    }
            )
            .frame(width: geometry.size.width * 0.2)
    }
}

struct ExpandButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Image(systemName: isExpanded ? "chevron.right" : "chevron.left")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .padding(.vertical, 30)
            .padding(.horizontal, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.trailing, -15)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            )
    }
}

struct HeaderView: View {
    var isExpanded: Bool
    
    var body: some View {
        Text("Personagens")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .opacity(isExpanded ? 1 : 0) // Show only if expanded
            .transition(.move(edge: .trailing).combined(with: .opacity))
            .padding()
    }
}

struct DraggableInstrumentCardView: View {
    let instrument: Instruments
    let geometry:GeometryProxy
    
    @Binding var dragOffsets: [Instruments: CGSize]
    @Binding var draggingInstrument: Instruments?
    @Binding var currentDragOffset: CGSize
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    let isDrop: (CGRect, CGPoint) -> Bool
    
    var body: some View {
        InstrumentCardView(instrumentInfo: InstrumentInfo.get(for: instrument))
            .scaleEffect(draggingInstrument == instrument ? 1.1 : 1.0)
            .opacity((draggingInstrument != nil) ? 0 : 1)
            .offset(dragOffsets[instrument, default: .zero])
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffsets[instrument] = value.translation
                        currentDragOffset = value.translation
                        withAnimation {
                            draggingInstrument = instrument
                        }
                    }
                    .onEnded { value in
                        dragOffsets[instrument] = .zero
                        currentDragOffset = .zero
                        if  isDrop(geometry.frame(in: .global), value.location){
                            arViewManager.arView?.loadInstrumentModel(instrument: instrument)
                        }
                        withAnimation {
                            draggingInstrument = nil
                        }
                    }
            )
    }
}

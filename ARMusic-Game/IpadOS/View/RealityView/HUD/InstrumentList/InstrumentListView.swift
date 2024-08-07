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
                    ExpandButton(isExpanded: $isExpanded)
                    VStack(alignment: .leading, spacing: 0) {
                        HeaderView(isExpanded: isExpanded)
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(instruments, id: \.self) { instrument in
                                ZStack {
                                    InstrumentCardDraggingView(
                                        instrument: instrument, geometry: geometry,
                                        currentDragOffset: $currentDragOffset, isExpanded: $isExpanded
                                    )
                                    
                                    DraggableInstrumentCardView(
                                        instrument: instrument, geometry: geometry, isExpanded: $isExpanded,
                                        dragOffsets: $dragOffsets,
                                        draggingInstrument: $draggingInstrument,
                                        currentDragOffset: $currentDragOffset,
                                        isDrop:  isDropLocationOutside
                                    )
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.4)
                        
                        Spacer()
                    }
                    .padding(5)
                    .transition(.move(edge: .trailing))
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                    )
                    .frame(width: geometry.size.width * 0.4)
                }
                .offset(x: isExpanded ? geometry.size.width * 0.28 : geometry.size.width * 0.6825)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func isDropLocationOutside(_ geometry: GeometryProxy, _ location: CGSize) -> Bool {
        let dropAreaWidth = geometry.size.width * 0.45
        return abs(location.width) > dropAreaWidth / 2
    }

}

struct InstrumentCardDraggingView: View {
    let instrument: Instruments
    let geometry: GeometryProxy
    @Binding var currentDragOffset: CGSize
    @Binding var isExpanded: Bool
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
        
    var body: some View {
        USDZSceneView(modelName: "guitarra.usdz")
            .scaleEffect(1.5)
            .offset(currentDragOffset)
            .opacity(isExpanded ? 0 : 1)
            .frame(width: geometry.size.width * 0.2)
            .opacity(currentDragOffset != .zero ? 1 : 0)
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
            .opacity(isExpanded ? 1 : 0)
            .transition(.move(edge: .trailing).combined(with: .opacity))
            .padding()
    }
}

struct DraggableInstrumentCardView: View {
    let instrument: Instruments
    let geometry: GeometryProxy
    
    @Binding var isExpanded: Bool
    @Binding var dragOffsets: [Instruments: CGSize]
    @Binding var draggingInstrument: Instruments?
    @Binding var currentDragOffset: CGSize
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    @State private var isPressed = false
    
    let isDrop: (GeometryProxy, CGSize) -> Bool
    
    var body: some View {
        InstrumentCardView(instrumentInfo: InstrumentInfo.get(for: instrument))
            .scaleEffect(draggingInstrument == instrument ? 1.1 : (isPressed ? 0.9 : 1.0))
            .opacity(isExpanded ? 1 : 0)
            .offset(dragOffsets[instrument, default: .zero])
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = false
                    }
                }
                arViewManager.arView?.loadInstrumentModel(instrument: instrument)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        dragOffsets[instrument] = value.translation
                        currentDragOffset = value.translation
                        withAnimation {
                            draggingInstrument = instrument
                            if isDrop(geometry, value.translation) {
                                isExpanded = false
                                
                                return
                            }
                            
                            isExpanded = true
                        }
                    }
                    .onEnded { value in
                        print(isDrop(geometry, value.translation))
                        if isDrop(geometry, value.translation) {
                            arViewManager.arView?.loadInstrumentModel(instrument: instrument)
                        }
                        dragOffsets[instrument] = .zero
                        currentDragOffset = .zero
                        withAnimation {
                            draggingInstrument = nil
                        }
                    }
            )
    }
}

struct USDZSceneView: UIViewRepresentable {
    let modelName: String
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        
        // Carregar a cena com o modelo USDZ de forma assíncrona
        loadModelAsync(modelName: modelName) { scene in
            DispatchQueue.main.async {
                sceneView.scene = scene
                sceneView.scene?.rootNode.scale = SCNVector3(x: 0.85, y: 0.85, z: 0.85)
            }
        }
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Atualizações necessárias quando a view é atualizada
    }
    
    private func loadModelAsync(modelName: String, completion: @escaping (SCNScene?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let scene = SCNScene(named: modelName)
            completion(scene)
        }
    }
}

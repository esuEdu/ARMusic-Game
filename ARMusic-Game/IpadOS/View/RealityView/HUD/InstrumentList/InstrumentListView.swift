import SwiftUI
import ARPackage
import ARKit
import RealityKit
import DataPackage

struct InstrumentListView: View {
    @Binding var isExpanded: Bool
    @State private var dragOffsets: [Instruments: CGSize] = [:]
    @State private var draggingInstrument: Instruments?
    @State private var currentDragOffset: [Instruments: CGSize] = {
        var offsets = [Instruments: CGSize]()
        Instruments.allCases.forEach { instrument in
            offsets[instrument] = .zero
        }
        return offsets
    }()
    
    
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
                                    // Modelo 3d do instrumento exibido ao arrastar
                                    InstrumentCardDraggingView(
                                        instrument: instrument, geometry: geometry,
                                        currentDragOffset: $currentDragOffset, isExpanded: $isExpanded
                                    )
                                    
                                    // Card do instrumento
                                    DraggableInstrumentCardView(
                                        instrument: instrument, geometry: geometry, isExpanded: $isExpanded,
                                        dragOffsets: $dragOffsets,
                                        draggingInstrument: $draggingInstrument,
                                        currentDragOffset: $currentDragOffset,
                                        isDrop:  isDropLocationOutside
                                    )
                                }
                                .frame(height: geometry.size.height * 0.58)
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
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(hex: "6F5ED9"), location: 0.0),
                                    .init(color: Color(hex: "5447A3"), location: 0.5),
                                    .init(color: Color(hex: "3B3273"), location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            )
                            .blur(radius: 8.1)
                            .blendMode(.multiply)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    )
                    .frame(width: geometry.size.width * 0.4)
                }
                .offset(x: isExpanded ? geometry.size.width * 0.28 : geometry.size.width * 0.6825)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func isDropLocationOutside(_ geometry: GeometryProxy, _ location: CGSize, instrument: Instruments) -> Bool {
        
        let instrumentIndex = Instruments.allCases.firstIndex(of: instrument) ?? 0
        let columnIndex = instrumentIndex % 2 // Assuming 2 columns
        
        let dropAreaWidth: CGFloat
        if columnIndex == 0 {
            dropAreaWidth = geometry.size.width * 0.45
        } else {
            dropAreaWidth = geometry.size.width * 0.85
        }
        
        // Check if the drop location is outside the defined area
        return abs(location.width) > dropAreaWidth / 2
    }
    
    
}

struct InstrumentCardDraggingView: View {
    let instrument: Instruments
    let geometry: GeometryProxy
    @Binding var currentDragOffset: [Instruments: CGSize]
    @Binding var isExpanded: Bool
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    var body: some View {
        if let modelURL = ModelData(instrument: instrument).getURL() {
            USDZSceneView(modelURL: modelURL)
                .scaleEffect(1.5)
                .offset(currentDragOffset[instrument] ?? .zero)
                .opacity(isExpanded ? 0 : 1)
                .frame(width: geometry.size.width * 0.2)
                .opacity(currentDragOffset[instrument] != .zero ? 1 : 0)
        }
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
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.clear)
                    .overlay{
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .gradiente1, location: 0.0),
                                .init(color: .gradiente2, location: 0.5),
                                .init(color: .gradiente3, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
            )
            .clipShape(RoundedRectangle(cornerRadius: 100))
            .padding(.trailing, -5)
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
        HStack{
            Image(.budies)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .containerRelativeFrame(.horizontal){ width, _ in width * 0.2}
                .opacity(isExpanded ? 1 : 0)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct DraggableInstrumentCardView: View {
    let instrument: Instruments
    let geometry: GeometryProxy
    
    @Binding var isExpanded: Bool
    @Binding var dragOffsets: [Instruments: CGSize]
    @Binding var draggingInstrument: Instruments?
    @Binding var currentDragOffset: [Instruments: CGSize]
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    @State private var isPressed = false
    
    let isDrop: (GeometryProxy, CGSize, Instruments) -> Bool
    
    var body: some View {
        InstrumentCardView(instrumentInfo: InstrumentInfo.get(for: instrument))
            .scaleEffect(draggingInstrument == instrument ? 1.1 : (isPressed ? 0.9 : 1.0))
            .zIndex(draggingInstrument == instrument ? 99 : 0)
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
                        currentDragOffset[instrument] = value.translation
                        withAnimation {
                            draggingInstrument = instrument
                            if isDrop(geometry, value.translation, instrument) {
                                isExpanded = false
                                
                                return
                            }
                            
                            isExpanded = true
                        }
                    }
                    .onEnded { value in
                        if isDrop(geometry, value.translation, instrument) {
                            arViewManager.arView?.loadInstrumentModel(instrument: instrument)
                        }
                        dragOffsets[instrument] = .zero
                        currentDragOffset[instrument] = .zero
                        withAnimation {
                            draggingInstrument = nil
                        }
                    }
            )
    }
}

struct USDZSceneView: UIViewRepresentable {
    let modelURL: URL
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        
        // Carregar a cena com o modelo USDZ de forma assíncrona
        loadModelAsync(modelURL: modelURL) { scene in
            DispatchQueue.main.async {
                sceneView.scene = scene
                sceneView.scene?.rootNode.scale = SCNVector3(x: 0.82, y: 0.82, z: 0.82)
            }
        }
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
    }
    
    private func loadModelAsync(modelURL: URL, completion: @escaping (SCNScene?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let scene = try? SCNScene(url: modelURL, options: nil)
            completion(scene)
        }
    }
}

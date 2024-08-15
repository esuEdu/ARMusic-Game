import SwiftUI

// MARK: - Library View
struct LibraryView: View {
    @State private var data: [CDItem] = [
        CDItem(text: "Item 1", descricao: "Rock"),
        CDItem(text: "Item 2", descricao: "Filantropia"),
        CDItem(text: "Item 3", descricao: "Estequiometria"),
        CDItem(text: "Item 4", descricao: "Esternocleidomastoide")
    ]
    
    @State private var searchText: String = ""
    @State private var selectedItem: CDItem? = nil
    @State private var showModal: Bool = false
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height

    private let mainAreaSize: CGFloat = 0.6712
    private let playerAreaSize: CGFloat = 0.323
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Toolbar(searchText: $searchText)
                    LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 80) {
                        ForEach($data) { $item in
                            CDGridItemView(
                                item: $item,
                                dragOffsets: $dragOffsets,
                                data: $data,
                                onItemSelected: selectItem
                            )
                        }
                    }
                    .padding(.top, 80)
                    .padding(.leading, 30)
                }
                .frame(width: geometry.size.width * mainAreaSize)
                .zIndex(99)
                
                VStack {
                    PlayerView(selectedItem: $selectedItem, showModal: $showModal)
                }
                .frame(width: geometry.size.width * playerAreaSize)
                .background(Color.clear)
            }
            .onChange(of: showModal) { isPresented in
                withAnimation(.spring()) {
                    offsetY = isPresented ? 0 : UIScreen.main.bounds.height
                }
            }
            
            // Custom Modal
            if showModal {
                DetailCDModalView(item: selectedItem ?? CDItem(text: "", descricao: ""), isPresented: $showModal)
                    .offset(y: offsetY)
                    .transition(.move(edge: .bottom))
                    .zIndex(100)
            }
        }

        .frame(maxHeight: .infinity)
        .background(
            Image("background").resizable()
                .frame(minWidth: UIScreen.screenWidth * 1)
                .frame(minHeight: UIScreen.screenHeight * 1.005)
        )
    }
    
    // Função para garantir que apenas um item esteja definido como `isDefinido = true`
    private func selectItem(_ selectedItem: CDItem) {
        for i in data.indices {
            data[i].isDefinido = (data[i].id == selectedItem.id)
        }
        self.selectedItem = selectedItem
    }
}


/// Usado para exibir o CD girando
struct PlayerCircle: View {
    @Binding var selectedItem: CDItem?
    @State private var rotation: Double = 0
    
    let playerSize: CGFloat = UIScreen.screenWidth * 0.2342
    let circleDiameter: CGFloat = UIScreen.screenWidth * 0.08

    var body: some View {
        Image("junckbox")
            .foregroundColor(.green)
            .frame(width: playerSize, height: playerSize)
            .overlay {
                if selectedItem != nil {
                    ZStack {
//                        Circle()
//                            .foregroundColor(.black)
//                            .padding()
//
//                        Circle()
//                            .foregroundColor(.white)
                        Image("disco")
                            .frame(width: circleDiameter)
                    }
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        startRotation()
                    }
                    .onDisappear {
                        stopRotation()
                    }
                    .compositingGroup() // Needed to properly apply the blend mode
                } else {
//                    Circle()
//                        .foregroundStyle(.brown)
//                        .padding()
                }
            }
            .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
    }
    
    private func startRotation() {
        rotation = 360
    }
    
    private func stopRotation() {
        rotation = 0
    }
}



// MARK: - Preview
#Preview {
    LibraryView()
}

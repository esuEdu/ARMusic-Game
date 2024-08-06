import SwiftUI

struct CDItem: Identifiable {
    let id = UUID()
    let text: String
}

struct LibraryView: View {
    
    private var data: [CDItem] = [
        CDItem(text: "Item 1"),
        CDItem(text: "Item 2"),
        CDItem(text: "Item 3"),
        CDItem(text: "Item 4"),
    ]
    private let fixedColumns = [
        GridItem(),
        GridItem()
    ]
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var draggedItem: CDItem? = nil
    @State private var itemPositions: [UUID: CGSize] = [:]
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    toolbar
                    
                    scroll
                }
                .frame(width: UIScreen.main.bounds.width * 0.6712)
                .foregroundStyle(.gray)
                
                //MARK: - Tocador
                player
                    .frame(width: UIScreen.main.bounds.width * 0.323)
                    .foregroundStyle(.black.opacity(0.8))
            }
        }
    }
    
    func cd() -> some View {
        VStack {
            Rectangle()
                .frame(
                    width: UIScreen.main.bounds.width * 0.183,
                    height: UIScreen.main.bounds.height * 0.244
                )
                .padding(.bottom, 40)
            
            Text("Lorem ipsum dolor sit amet consecteur adpiscing elit, sed do ejusmod tempor.")
                .bold()
                .foregroundStyle(.black)
        }
    }
    
    
    
    
    func btn(_ text: String) -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundStyle(.pink)
            .overlay {
                Text(text)
                    .foregroundStyle(.blue)
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical, 40)
                    .padding(.horizontal, 150)
            }
            .onTapGesture {
                print("clicked")
            }
    }
    
    var toolbar: some View {
        HStack {
            Circle()
                .frame(width: UIScreen.main.bounds.width * 0.1025,height: UIScreen.main.bounds.height * 0.1367)
                .foregroundStyle(.gray)
                .overlay {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 32))
                        .fontWeight(.heavy)
                        .foregroundStyle(.black)
                }
            
            Spacer()
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                TextField("Pesquisar", text: $searchText)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(width: UIScreen.main.bounds.width * 0.5)
            Spacer()
            
            Circle()
                .frame(
                    width: UIScreen.main.bounds.width * 0.1025,
                    height: UIScreen.main.bounds.height * 0.1367
                )
                .foregroundStyle(.gray)
                .overlay {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .font(.system(size: 32))
                        .fontWeight(.heavy)
                        .foregroundStyle(.black)
                }
            
        }
    }
    
    //MARK: - Player
    var player: some View {
        Rectangle()
            .frame(maxHeight: .infinity)
            .foregroundStyle(.blue)
            .overlay {
                VStack {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .padding()
                        .overlay {
                            Text("Lorem ipsum dolor sit amet consectur adipiscing elit, sed do eiusmod tempor.")
                                .bold()
                                .padding()
                        }
                    
                    Rectangle()
                        .foregroundStyle(.green)
                        .padding()
                        .frame(
                            width: UIScreen.main.bounds.width * 0.2672,
                            height: UIScreen.main.bounds.height * 0.3564
                        )
                    Circle()
                        .overlay {
                            Image(systemName: "pause.fill")
                                .bold()
                                .foregroundStyle(.red)
                        }
                        .overlay {
                            tocador
                        }
                    
                    
                    //                    Button("Entrar") {
                    //                        print("oie")
                    //                    }
                    //                    .foregroundStyle(.red)
                    
                    btn("Entrar")
                    
                }
            }
            .overlay(alignment: .topTrailing) {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text("...")
                            .bold()
                            .foregroundStyle(.white)
                    }
            }
    }
    
    var scroll: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: fixedColumns) {
                ForEach(data) { item in
                    ZStack {
                        cd()
                            .offset(itemPositions[item.id] ?? .zero)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        isDragging = true
                                        draggedItem = item
                                        dragOffset = value.translation
                                        itemPositions[item.id] = dragOffset
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        print("Item \(item.text) movido para: \(dragOffset)")
                                        draggedItem = nil
                                        dragOffset = .zero
                                    }
                            )
                        
                    }
                    //       .zIndex(draggedItem == item ? 1 : 0)
                    //                    .overlay {
                    //                        Text(item.text)
                    //                            .font(.largeTitle)
                    //                            .bold()
                    //                            .fontDesign(.rounded)
                    //                            .foregroundStyle(.black)
                    //                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.66)
        .background(Color.blue)
    }
    
    var tocador: some View {
        Circle()
            .foregroundStyle(.black)
            .frame(width: 100, height: 100)
            .overlay(
                Text("Tocador")
                    .foregroundColor(.white)
            )
    }
}

#Preview {
    LibraryView()
}

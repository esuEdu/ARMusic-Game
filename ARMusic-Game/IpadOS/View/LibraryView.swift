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
            // back button
            ZStack {
                Circle()
                    .frame(width: UIScreen.main.bounds.width * 0.1025,height: UIScreen.main.bounds.height * 0.1367)
                    .foregroundStyle(.gray)
                    .overlay {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 32))
                            .fontWeight(.heavy)
                            .foregroundStyle(.black)
                    }
            }
            .padding(.leading, 20)
            
            Spacer()
            
            // search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                TextField("Pesquisar", text: $searchText)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity)
            Spacer()
            
            // filter button
            ZStack {
                Circle()
                    .frame(width: UIScreen.main.bounds.width * 0.1025, height: UIScreen.main.bounds.height * 0.1367)
                    .foregroundStyle(.gray)
                    .overlay {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.system(size: 32))
                            .fontWeight(.heavy)
                            .foregroundStyle(.black)
                    }
            }
            .padding(.trailing, 20)
            
        }
        .background(.clear)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
            
    }
    
    //MARK: - Player
    var player: some View {
        VStack {
            moreOptionsButton
            
            explicationCDText
            
            Rectangle()
                .foregroundStyle(.green)
                .frame(width: UIScreen.main.bounds.width * 0.2672,height: UIScreen.main.bounds.height * 0.3564)
                .overlay {
                    tocador
                }

            
            Circle()
                .foregroundStyle(.black)
                .overlay {
                    Image(systemName: "pause.fill")
                        .bold()
                        .foregroundStyle(.red)
                }
                        
            Button("Entrar") {
                
            }
            
        }
        .padding(36)
        .background(.gray)
    }
    
    var scroll: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: fixedColumns) {
                ForEach(data) { item in
                    itemCDScrollView(item: item)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.66)
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
    
    var moreOptionsButton: some View {
        HStack {
            Spacer()
            Circle()
                .frame(width: 50, height: 50)
                .overlay {
                    Text("...")
                        .bold()
                        .foregroundStyle(.white)
                }
        }
    }
    
    var explicationCDText: some View {
        Rectangle()
            .foregroundStyle(.blue)
            .overlay {
                Text("Lorem ipsum dolor sit amet consectur adipiscing elit, sed do eiusmod tempor.")
                    .bold()
                    .padding()
                    .font(.caption)
            }
            .frame(width: UIScreen.main.bounds.width * 0.2342,height: UIScreen.main.bounds.height * 0.2416)
    }
    
    func itemCDScrollView(item: CDItem) -> some View {
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

#Preview {
    LibraryView()
}

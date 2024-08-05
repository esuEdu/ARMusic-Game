import SwiftUI

struct LibraryView: View {
    
    private var data: [Int] = Array(1...20)
    private let colors: [Color] = [.red, .green, .blue, .yellow]
    private let fixedColumns = [
        GridItem(),
        GridItem()
    ]
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var draggedItem: Int? = nil
    @State private var itemPositions: [Int: CGSize] = [:]
    
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
            }
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
                .frame(
                    width: UIScreen.main.bounds.width * 0.1025,
                    height: UIScreen.main.bounds.height * 0.1367
                )
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
                            Text("Lorem ipsum dolor site amet consectur adpiscing elit, sed do ejusmod tempor.")
                                .bold()
                                .padding()
                        }
                    Rectangle()
                        .foregroundStyle(.gray)
                        .padding()
                        .overlay {
                            tocador
                        }
                    
                    Circle()
                        .overlay {
                            Image(systemName: "pause.fill")
                                .bold()
                                .foregroundStyle(.red)
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
                ForEach(data, id: \.self) { number in
                    ZStack {
                        Rectangle()
                            .foregroundStyle(colors[number % 4])
                            .frame(height: 150)
                            .offset(itemPositions[number] ?? .zero)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        isDragging = true
                                        draggedItem = number
                                        dragOffset = value.translation
                                        itemPositions[number] = dragOffset
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        print("Retângulo \(number) movido para: \(dragOffset)")
                                        draggedItem = nil
                                        dragOffset = .zero
                                    }
                            )
                        
                    }
                    .zIndex(draggedItem == number ? 1 : 0)
                    .overlay {
                        Text("\(number)")
                            .font(.largeTitle)
                            .bold()
                            .fontDesign(.rounded)
                    }
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
    
    func cdCapa() -> some View {
        Rectangle()
            .frame(
                width: UIScreen.main.bounds.width * 0.183,
                height: UIScreen.main.bounds.height * 0.244
            )
    }
    
    func cd() -> some View {
        Circle()
            .frame(
                width: UIScreen.main.bounds.width * 0.183,
                height: UIScreen.main.bounds.height * 0.244
            )
    }
}

#Preview {
    LibraryView()
}

//
//  CDGridItem.swift
//  ImageParallax
//
//  Created by Thiago Pereira de Menezes on 12/08/24.
//

import SwiftUI

struct CDGridItemView: View {
    @Binding var item: CDItem
    @Binding var dragOffsets: [UUID: CGSize]
    @Binding var data: [CDItem]
    
    private let rectangleSize: CGFloat = 282.0
    private let tamanhoDosCDS: CGFloat = UIScreen.screenWidth * 0.13
    
    var onItemSelected: (CDItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                GeometryReader { geometry in
                    if !item.isDefinido {
                        Image("disco")
                            .resizable()
                            .foregroundStyle(.cd)
                            .offset(x: geometry.size.width / 2)
                            .offset(dragOffsets[item.id] ?? .zero)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffsets[item.id] = value.translation
                                    }
                                    .onEnded { value in
                                        handleDrop(value: value)
                                    }
                            )
                    }
                }
                
                Image("capaDisco")
                    .resizable()
                    .foregroundStyle(.capaCD)
                    .frame(width: rectangleSize, height: rectangleSize)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondaryPurple.opacity(0.5))
                    .frame(width: rectangleSize, height: 50)
                Text(item.descricao)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(width: rectangleSize)


        }
        .frame(width: rectangleSize, height: rectangleSize)
        .padding(.bottom, 40)
    }
    
    private func handleDrop(value: DragGesture.Value) {
        let dropPosition = value.location.x
        let dropThreshold = UIScreen.screenWidth * 0.3
        
        if dropPosition > dropThreshold {
            // Utilize a função para selecionar o item
            onItemSelected(item)
            dragOffsets[item.id] = .zero
        } else {
            dragOffsets[item.id] = .zero
        }
    }
}
//#Preview {
//    CDGridItemView(item: <#T##Binding<CDItem>#>, rectangleSize: <#T##CGFloat#>, tamanhoDosCDS: <#T##CGFloat#>, dragOffsets: <#T##Binding<[UUID : CGSize]>#>, draggingCD: <#T##Binding<CDItem?>#>, selectedItem: <#T##Binding<CDItem?>#>, data: <#T##Binding<[CDItem]>#>, onItemSelected: <#T##(CDItem) -> Void#>)
//}

#Preview {
    LibraryView()
}

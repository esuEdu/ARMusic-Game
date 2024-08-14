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
    
    private let rectangleSize: CGFloat = 200.0
    private let tamanhoDosCDS: CGFloat = UIScreen.screenWidth * 0.13
    
    var onItemSelected: (CDItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                GeometryReader { geometry in
                    if !item.isDefinido {
                        Circle()
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
                
                Rectangle()
                    .foregroundStyle(.capaCD)
                    .frame(width: rectangleSize, height: rectangleSize)
            }
            Text(item.descricao)
                .bold()
                .foregroundColor(.black)
                .frame(width: tamanhoDosCDS * 1.3)
                .multilineTextAlignment(.center)
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

//
//  StartView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 30/07/24.
//

import SwiftUI

struct StartView: View {
    
    
    var body: some View {
        HStack {
            VStack{
                btn()
                
                Button("btn2") {
                    
                }
            }
            
            Text("anatomia")
        }
    }
    
    func btn() -> some View {        RoundedRectangle(cornerRadius: 25.0)
            .overlay {
                Text("text")
                    .font(.title)
            }
            .onTapGesture {
                print("clicked")
            }
    }
}

#Preview {
    StartView()
}

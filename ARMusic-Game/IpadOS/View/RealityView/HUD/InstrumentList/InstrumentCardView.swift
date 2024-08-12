//
//  InstrumentCardView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 04/08/24.
//

import SwiftUI

struct InstrumentCardView: View {
    var instrumentInfo: InstrumentInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack{
                VStack{
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .gradiente1, location: 0.0),
                                .init(color: .gradiente2, location: 0.5),
                                .init(color: .gradiente3, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .blur(radius: 8.1)
                        .blendMode(.multiply)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }

                VStack {
                    VStack{
                        Image(instrumentInfo.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(.rect(cornerRadius: 15))
                            .containerRelativeFrame(.vertical){ height, _ in height * 0.18}
                            .padding(.vertical, 5)
                        
                        VStack(spacing: 5) {
                            Image(instrumentInfo.name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .multilineTextAlignment(.center)
                                .containerRelativeFrame(.vertical){ height, _ in height * 0.09}
                            
                            Text(instrumentInfo.description)
                                .customFont(.goodBakwan, textStyle: .footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                    .padding(30)
                    
                    Spacer()
                }
            }
        }
        .background(
            Image(.backgroundCardInstrument)
                .resizable()
                .aspectRatio(contentMode: .fit)
        )
        .clipShape(.rect(cornerRadius: 15))
    }
}


//#Preview {
//    InstrumentCardView(instrumentInfo: InstrumentInfo(name: "", imageName: "", description: ""))
//}

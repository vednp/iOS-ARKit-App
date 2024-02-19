//
//  ContentView.swift
//  ARKit-IOS
//
//  Created by Ved Pahune on 18/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var colors: [Color] = [
        .white,
        .red,
        .blue
    ]
    
    var body: some View {
        CustomARViewRepresentable().ignoresSafeArea()
            .overlay(alignment: .bottom) {
                ScrollView(.horizontal) {
                    HStack {
                        Button {
                            ARManager.shared.actionStream.send(.removeAllAnchors)
                        } label:{
                            Image(systemName: "trash" )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(16)
                        }
                        ForEach(colors, id: \.self ){ color in
                            Button {
                                ARManager.shared.actionStream.send(.placeSphere(color: color))
                            } label:{
                                color
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(.regularMaterial)
                                    .cornerRadius(16)
                            }
                        }
                    }.padding()
                }
            }
    }
}

#Preview {
    ContentView()
}

//
//  FlowerBackgroundView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 02/12/25.
//

import SwiftUI

struct BackgroundView: View {
    private let sky = Color(red: 163/255, green: 214/255, blue: 208/255)
    private let mist = Color(red: 243/255, green: 250/255, blue: 249/255)
    private let grass = Color(red: 205/255, green: 229/255, blue: 195/255)
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: sky,   location: 0.0),  // top sky
                    .init(color: mist,  location: 0.5),  // center fog/mist
                    .init(color: grass, location: 1.0)   // bottom grass
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}

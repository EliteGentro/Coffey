//
//  InitialProfileCircleView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct InitialProfileCircleView: View {
    let name : String
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.8))
                .frame(width: 80, height: 80)
            Text(String(name.prefix(1)).uppercased())
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    InitialProfileCircleView(name: "Humberto")
}

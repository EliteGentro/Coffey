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
                .fill(Color.brown.opacity(0.8))
                .frame(width: 80, height: 80)
            Text(String(name.prefix(1)).uppercased())
                .scaledFont(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    InitialProfileCircleView(name: "Humberto")
        .withPreviewSettings()

}

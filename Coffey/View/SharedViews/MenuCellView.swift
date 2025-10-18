//
//  MenuCellView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct MenuCellView: View {
    let systemName: String
    let title: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemName)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 40))

            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        .contentShape(Rectangle())
        .accessibilityElement()
        .accessibilityLabel(title) // original string works for VoiceOver
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    MenuCellView(systemName: "house.fill", title: "house")
}

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
    let color: Color

    init(systemName: String, title: String, color: Color = .brown) {
        self.systemName = systemName
        self.title = title
        self.color = color
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemName)
                .imageScale(.large)
                .foregroundStyle(color)
                .scaledFont(.system(size: 40))

            Text(title)
                .scaledFont(.headline).foregroundColor(color)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.1)))
        .contentShape(Rectangle())
        .accessibilityElement()
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    MenuCellView(systemName: "house.fill", title: "house")
}

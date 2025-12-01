//
// ScaledText.swift
// Coffey
//
// Created by Alumno on 21/11/2025.
//

import SwiftUI

struct ScaledText: View {
    @EnvironmentObject var fontSettings: FontSettings
    let content: String
    let textStyle: Font.TextStyle

    init(_ content: String, style: Font.TextStyle = .body) {
        self.content = content
        self.textStyle = style
    }

    var body: some View {
        Text(content)
            .scaledFont(.system(size: styleToBaseSize(textStyle) * fontSettings.multiplier))
    }

    private func styleToBaseSize(_ style: Font.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .subheadline: return 15
        case .body: return 17
        case .callout: return 16
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default:
            return 17
        }
    }
}
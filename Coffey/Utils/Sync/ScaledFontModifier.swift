struct ScaledFontModifier: ViewModifier {
    @EnvironmentObject var fontSettings: FontSettings
    let style: Font.TextStyle

    func body(content: Content) -> some View {
        content.scaledFont(font(for: style))
    }

    private func font(for style: Font.TextStyle) -> Font {
        let baseSize: CGFloat

        switch style {
        case .largeTitle:   baseSize = 34
        case .title:        baseSize = 28
        case .title2:       baseSize = 22
        case .title3:       baseSize = 20
        case .headline:     baseSize = 17
        case .subheadline:  baseSize = 15
        case .body:         baseSize = 17
        case .callout:      baseSize = 16
        case .footnote:     baseSize = 13
        case .caption:      baseSize = 12
        case .caption2:     baseSize = 11
        @unknown default:   baseSize = 17
        }

        return .system(size: baseSize * fontSettings.multiplier)
    }
}

extension View {
    func scaledFont(_ style: Font.TextStyle) -> some View {
        self.modifier(ScaledFontModifier(style: style))
    }
}

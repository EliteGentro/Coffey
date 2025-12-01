import SwiftUI

struct GlobalFontModifier: ViewModifier {
    @EnvironmentObject var fontSettings: FontSettings

    func body(content: Content) -> some View {
        content.environment(\.font,
            .system(size: 17 * fontSettings.multiplier)
        )
    }
}

extension View {
    func applyGlobalFontScaling() -> some View {
        self.modifier(GlobalFontModifier())
    }
}

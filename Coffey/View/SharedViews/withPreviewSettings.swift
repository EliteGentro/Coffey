//
//  withPreviewSettings.swift
//  Coffey
//
//  Created by Alumno on 04/12/25
//

import SwiftUI

extension View{
    func withPreviewSettings(multiplier: CGFloat = 1.0) -> some View {
        let fontSettings = FontSettings()
        fontSettings.multiplier = multiplier
        return self.environmentObject(fontSettings)
    }
}
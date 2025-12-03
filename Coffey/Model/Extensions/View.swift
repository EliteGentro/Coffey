//
//  View.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 02/12/25.
//

import Foundation
import SwiftUI

extension View {
    /// A card background that prevents blending with the global background.
    func beigeCardBackground(
        cornerRadius: CGFloat = 12,
        tint: Color = Color.brown.opacity(0.1)
    ) -> some View {
        self.background(
            ZStack {
                Color.beige           // solid layer preventing blend issues
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(tint)      // translucent decorative layer
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
    }
    
    func flowerFullBackground(
            patternOpacity: CGFloat = 0.4,
            blend: BlendMode = .sourceAtop
        ) -> some View {
            self.background(
                ZStack {
                    LinearGradient(
                        colors: [.cyan.opacity(0.6), .green.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    Image("flowerpattern")
                        .resizable()
                        .scaledToFill()
                        .opacity(patternOpacity)
                        .blendMode(blend)
                        .ignoresSafeArea()
                }
            )
        }
    
    func beigeTintedBackground(
            color: Color,
            cornerRadius: CGFloat = 12
        ) -> some View {
            self.background(
                ZStack {
                    Color.beige
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(color.opacity(0.1))
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
        }
    func whiteTranslucentBackground(
            opacity: Double = 0.5,
            cornerRadius: CGFloat = 12
        ) -> some View {
            self.background(
                ZStack {
                    Color.white.opacity(opacity)                             // solid base (no blending)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(opacity))  // translucent overlay
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
        }
    func glassCard(
            cornerRadius: CGFloat = 16,
            opacity: Double = 0.25
        ) -> some View {
            self.background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(opacity))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.white.opacity(opacity * 0.8))
                    )
                    .blur(radius: 0.2)
            )
        }
}

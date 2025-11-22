//
//  ColorNaming.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

enum ColorName {
    static func name(for color: UIColor) -> String {
        // Call AXNameFromColor where available (iOS 17+?), otherwise fallback.
        // For the prototype: simple nearestBasicColorName helper.
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return simpleName(Int(r*255), g: Int(g*255), b: Int(b*255))
    }

    private static func simpleName(_ r: Int, g: Int, b: Int) -> String { /* same bins as before */
        if r > 200 && g < 100 && b < 100 { return "red" }
        if g > 200 && r < 100 && b < 100 { return "green" }
        if b > 200 && r < 100 && g < 100 { return "blue" }
        if r > 200 && g > 200 { return "yellow" }
        if r < 60 && g < 60 && b < 60 { return "black" }
        return "muted color"
    }
}

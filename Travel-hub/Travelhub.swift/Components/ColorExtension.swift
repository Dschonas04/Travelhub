import SwiftUI

extension Color {
    // Parse hex string into RGBA components (0...1)
    private static func components(from hex: String) -> (r: Double, g: Double, b: Double, a: Double) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return (Double(r) / 255, Double(g) / 255, Double(b) / 255, Double(a) / 255)
    }

    // Default: sRGB
    init(hex: String) {
        let c = Color.components(from: hex)
        self.init(.sRGB, red: c.r, green: c.g, blue: c.b, opacity: c.a)
    }

    // Explicit color space initializer (e.g., .displayP3)
    init(hex: String, colorSpace: RGBColorSpace) {
        let c = Color.components(from: hex)
        self.init(colorSpace, red: c.r, green: c.g, blue: c.b, opacity: c.a)
    }

    // Convenience for Display P3
    static func p3(hex: String) -> Color {
        Color(hex: hex, colorSpace: .displayP3)
    }

    // Dynamic: use P3 on wide-gamut displays, sRGB fallback otherwise
    static func dynamicWideGamut(p3: (Double, Double, Double), srgbHex: String, opacity: Double = 1.0) -> Color {
        #if canImport(UIKit)
        if UIScreen.main.traitCollection.displayGamut == .P3 {
            return Color(.displayP3, red: p3.0, green: p3.1, blue: p3.2, opacity: opacity)
        } else {
            let c = Color.components(from: srgbHex)
            return Color(.sRGB, red: c.r, green: c.g, blue: c.b, opacity: c.a * opacity)
        }
        #else
        let c = Color.components(from: srgbHex)
        return Color(.sRGB, red: c.r, green: c.g, blue: c.b, opacity: c.a * opacity)
        #endif
    }
}

extension Color {
    // Wide-gamut accents for richer colors on supported displays
    static let appPrimary   = Color.dynamicWideGamut(p3: (0.12, 0.55, 0.98), srgbHex: "4A90D9")
    static let appSecondary = Color.dynamicWideGamut(p3: (0.34, 0.75, 0.93), srgbHex: "67B8DE")

    // Keep neutrals in sRGB for consistent appearance
    static let appBackground = Color(hex: "F5F7FA", colorSpace: .sRGB)
    static let appText       = Color(hex: "2C3E50", colorSpace: .sRGB)

    // Use system background for cards to respect appearance
    static let appCardBackground = Color(.systemBackground)

    // Budget category palette (dynamic P3 with sRGB fallbacks)
    static let budgetOrange = Color.dynamicWideGamut(p3: (1.00, 0.58, 0.00), srgbHex: "FF9500")
    static let budgetRed    = Color.dynamicWideGamut(p3: (1.00, 0.20, 0.15), srgbHex: "FF3B30")
    static let budgetPurple = Color.dynamicWideGamut(p3: (0.70, 0.30, 0.90), srgbHex: "AF52DE")
    static let budgetGreen  = Color.dynamicWideGamut(p3: (0.20, 0.85, 0.40), srgbHex: "34C759")
    static let budgetBlue   = Color.dynamicWideGamut(p3: (0.00, 0.54, 1.00), srgbHex: "007AFF")
}

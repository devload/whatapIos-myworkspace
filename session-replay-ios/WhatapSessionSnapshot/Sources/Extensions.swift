import Foundation
import UIKit

public extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        // First try getRed (works for RGB colors)
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return String(format: "#%02X%02X%02X%02X",
                          Int(red * 255),
                          Int(green * 255),
                          Int(blue * 255),
                          Int(alpha * 255))
        }

        // Fallback: convert to sRGB color space via CGColor
        guard let cgColor = self.cgColor,
              let srgbColor = cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
              let components = srgbColor.components,
              components.count >= 4 else {
            return "#00000000"
        }

        red = components[0]
        green = components[1]
        blue = components[2]
        alpha = components[3]

        return String(format: "#%02X%02X%02X%02X",
                      Int(red * 255),
                      Int(green * 255),
                      Int(blue * 255),
                      Int(alpha * 255))
    }
}

public extension UIFont {
    var fontWeight: Int {
        guard let traits = fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any],
              let weight = traits[.weight] as? NSNumber else {
            return 400
        }

        let weightValue = weight.doubleValue

        switch weightValue {
        case ..<0.1: return 100
        case 0.1..<0.2: return 200
        case 0.2..<0.3: return 300
        case 0.3..<0.4: return 400
        case 0.4..<0.5: return 500
        case 0.5..<0.6: return 600
        case 0.6..<0.7: return 700
        case 0.7..<0.8: return 800
        default: return 900
        }
    }
}

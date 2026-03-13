import Foundation
import UIKit

public struct ViewBounds: Codable {
    public let left: Double
    public let top: Double
    public let right: Double
    public let bottom: Double

    public init(rect: CGRect) {
        self.left = Double(rect.origin.x)
        self.top = Double(rect.origin.y)
        self.right = Double(rect.origin.x + rect.size.width)
        self.bottom = Double(rect.origin.y + rect.size.height)
    }

    public var rect: CGRect {
        CGRect(x: left, y: top, width: right - left, height: bottom - top)
    }
}

public struct ViewShadow: Codable {
    public let color: String?
    public let opacity: Double
    public let offsetWidth: Double
    public let offsetHeight: Double
    public let radius: Double

    public init?(shadow: CALayer) {
        guard shadow.shadowOpacity > 0 else { return nil }

        self.color = (shadow.shadowColor.map { UIColor(cgColor: $0).hexString })
        self.opacity = Double(shadow.shadowOpacity)
        self.offsetWidth = Double(shadow.shadowOffset.width)
        self.offsetHeight = Double(shadow.shadowOffset.height)
        self.radius = Double(shadow.shadowRadius)
    }
}

public struct ViewBorder: Codable {
    public let color: String?
    public let width: Double

    public init?(layer: CALayer) {
        guard layer.borderWidth > 0 else { return nil }

        self.color = layer.borderColor.map { UIColor(cgColor: $0).hexString }
        self.width = Double(layer.borderWidth)
    }
}

public struct ViewData: Codable {
    public let id: UInt
    public let type: String
    public let baseType: String?
    public let bounds: ViewBounds
    public let backgroundColor: String?
    public let alpha: Double
    public let visibility: String
    public let isHidden: Bool?

    // Text properties
    public let text: String?
    public let textSize: Double?
    public let textColor: String?
    public let fontWeight: Int?
    public let fontFamily: String?
    public let textAlignment: String?
    public let numberOfLines: Int?
    public let lineBreakMode: String?

    // Border and corner
    public let cornerRadius: Double?
    public let border: ViewBorder?
    public let shadow: ViewShadow?
    public let clipsToBounds: Bool?
    public let masksToBounds: Bool?

    // Tint and content
    public let tintColor: String?
    public let contentMode: String?
    public let imageTintColor: String?

    // Input properties
    public let placeholder: String?
    public let placeholderColor: String?
    public let isSecureTextEntry: Bool?
    public let isEnabled: Bool?
    public let isEditing: Bool?

    // Selection state
    public let isSelected: Bool?
    public let isHighlighted: Bool?

    // Control properties
    public let isOn: Bool?  // UISwitch
    public let value: Float?  // UISlider, UIProgressView
    public let minValue: Float?
    public let maxValue: Float?
    public let progress: Float?

    // Activity indicator
    public let isAnimating: Bool?

    // Scroll view
    public let contentOffset: PointData?
    public let contentSize: SizeData?

    // Image
    public let hasImage: Bool?
    public let imageName: String?

    public let children: [ViewData]?

    public init(
        id: UInt,
        type: String,
        baseType: String? = nil,
        bounds: ViewBounds,
        backgroundColor: String? = nil,
        alpha: Float = 1.0,
        visibility: String = "visible",
        isHidden: Bool? = nil,
        text: String? = nil,
        textSize: Float? = nil,
        textColor: String? = nil,
        fontWeight: Int? = nil,
        fontFamily: String? = nil,
        textAlignment: String? = nil,
        numberOfLines: Int? = nil,
        lineBreakMode: String? = nil,
        cornerRadius: Float? = nil,
        border: ViewBorder? = nil,
        shadow: ViewShadow? = nil,
        clipsToBounds: Bool? = nil,
        masksToBounds: Bool? = nil,
        tintColor: String? = nil,
        contentMode: String? = nil,
        imageTintColor: String? = nil,
        placeholder: String? = nil,
        placeholderColor: String? = nil,
        isSecureTextEntry: Bool? = nil,
        isEnabled: Bool? = nil,
        isEditing: Bool? = nil,
        isSelected: Bool? = nil,
        isHighlighted: Bool? = nil,
        isOn: Bool? = nil,
        value: Float? = nil,
        minValue: Float? = nil,
        maxValue: Float? = nil,
        progress: Float? = nil,
        isAnimating: Bool? = nil,
        contentOffset: PointData? = nil,
        contentSize: SizeData? = nil,
        hasImage: Bool? = nil,
        imageName: String? = nil,
        children: [ViewData]? = nil
    ) {
        self.id = id
        self.type = type
        self.baseType = baseType
        self.bounds = bounds
        self.backgroundColor = backgroundColor
        self.alpha = Double(alpha)
        self.visibility = visibility
        self.isHidden = isHidden
        self.text = text
        self.textSize = textSize.map { Double($0) }
        self.textColor = textColor
        self.fontWeight = fontWeight
        self.fontFamily = fontFamily
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
        self.cornerRadius = cornerRadius.map { Double($0) }
        self.border = border
        self.shadow = shadow
        self.clipsToBounds = clipsToBounds
        self.masksToBounds = masksToBounds
        self.tintColor = tintColor
        self.contentMode = contentMode
        self.imageTintColor = imageTintColor
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.isSecureTextEntry = isSecureTextEntry
        self.isEnabled = isEnabled
        self.isEditing = isEditing
        self.isSelected = isSelected
        self.isHighlighted = isHighlighted
        self.isOn = isOn
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.progress = progress
        self.isAnimating = isAnimating
        self.contentOffset = contentOffset
        self.contentSize = contentSize
        self.hasImage = hasImage
        self.imageName = imageName
        self.children = children
    }
}

public struct PointData: Codable {
    public let x: Double
    public let y: Double

    public init(point: CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }
}

public struct SizeData: Codable {
    public let width: Double
    public let height: Double

    public init(size: CGSize) {
        self.width = Double(size.width)
        self.height = Double(size.height)
    }
}

public struct FullSnapshot: Codable {
    public let timestamp: Int64
    public let screenWidth: Double
    public let screenHeight: Double
    public let scale: Double
    public let root: ViewData

    public init(root: ViewData, screenWidth: CGFloat, screenHeight: CGFloat, scale: CGFloat) {
        self.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        self.screenWidth = Double(screenWidth)
        self.screenHeight = Double(screenHeight)
        self.scale = Double(scale)
        self.root = root
    }
}

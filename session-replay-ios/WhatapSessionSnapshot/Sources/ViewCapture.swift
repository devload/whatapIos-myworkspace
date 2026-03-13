import Foundation
import UIKit

public class ViewCapture {

    public static let shared = ViewCapture()

    private init() {}

    public func captureWindow(_ window: UIWindow) -> FullSnapshot {
        let screenBounds = window.bounds
        let scale = window.screen.scale

        let rootView = captureView(window, in: screenBounds)

        return FullSnapshot(
            root: rootView,
            screenWidth: screenBounds.width,
            screenHeight: screenBounds.height,
            scale: scale
        )
    }

    public func captureView(_ view: UIView) -> ViewData {
        return captureView(view, in: view.bounds)
    }

    private func captureView(_ view: UIView, in screenBounds: CGRect) -> ViewData {
        // Force layout before capturing to get accurate bounds
        view.layoutIfNeeded()

        let viewBounds = view.bounds
        let screenFrame = view.convert(view.bounds, to: nil)
        let bounds = ViewBounds(rect: screenFrame)

        let visibility = getVisibility(view)
        let backgroundColor = view.backgroundColor?.hexString
        let cornerRadius = view.layer.cornerRadius > 0 ? Float(view.layer.cornerRadius) : nil
        let border = ViewBorder(layer: view.layer)
        let shadow = ViewShadow(shadow: view.layer)
        let clipsToBounds = view.clipsToBounds ? true : nil
        let masksToBounds = view.layer.masksToBounds ? true : nil
        let tintColor = view.tintColor?.hexString

        // Get base type for better type mapping
        let type = String(describing: type(of: view))
        let baseType = getBaseType(view)

        // Initialize all properties
        var text: String? = nil
        var textSize: Float? = nil
        var textColor: String? = nil
        var fontWeight: Int? = nil
        var fontFamily: String? = nil
        var textAlignment: String? = nil
        var numberOfLines: Int? = nil
        var lineBreakMode: String? = nil
        var placeholder: String? = nil
        var placeholderColor: String? = nil
        var isSecureTextEntry: Bool? = nil
        var isEnabled: Bool? = nil
        var isEditing: Bool? = nil
        var isSelected: Bool? = nil
        var isHighlighted: Bool? = nil
        var contentMode: String? = nil
        var imageTintColor: String? = nil
        var isOn: Bool? = nil
        var value: Float? = nil
        var minValue: Float? = nil
        var maxValue: Float? = nil
        var progress: Float? = nil
        var isAnimating: Bool? = nil
        var contentOffset: PointData? = nil
        var contentSize: SizeData? = nil
        var hasImage: Bool? = nil
        var imageName: String? = nil

        // Handle UILabel
        if let label = view as? UILabel {
            text = label.text
            if let font = label.font {
                textSize = Float(font.pointSize)
                fontWeight = font.fontWeight
                fontFamily = font.familyName
            }
            textColor = label.textColor?.hexString
            textAlignment = getTextAlignment(label.textAlignment)
            numberOfLines = label.numberOfLines
            lineBreakMode = getLineBreakMode(label.lineBreakMode)
            isEnabled = label.isEnabled
        }

        // Handle UIButton
        else if let button = view as? UIButton {
            text = button.title(for: .normal)
            if let font = button.titleLabel?.font {
                textSize = Float(font.pointSize)
                fontWeight = font.fontWeight
                fontFamily = font.familyName
            }
            textColor = button.titleLabel?.textColor?.hexString
            textAlignment = button.titleLabel.map { getTextAlignment($0.textAlignment) }
            numberOfLines = button.titleLabel?.numberOfLines
            lineBreakMode = button.titleLabel.map { getLineBreakMode($0.lineBreakMode) }
            isEnabled = button.isEnabled
            isSelected = button.isSelected
            isHighlighted = button.isHighlighted

            if let imageView = button.imageView {
                imageTintColor = imageView.tintColor?.hexString
                hasImage = imageView.image != nil
            }
            contentMode = getContentMode(button.imageView?.contentMode)
        }

        // Handle UITextField
        else if let textField = view as? UITextField {
            text = textField.text
            if let font = textField.font {
                textSize = Float(font.pointSize)
                fontWeight = font.fontWeight
                fontFamily = font.familyName
            }
            textColor = textField.textColor?.hexString
            textAlignment = getTextAlignment(textField.textAlignment)
            placeholder = textField.placeholder
            // Note: placeholder color requires private API, using default gray
            placeholderColor = "#C7C7CC" // System placeholder gray
            isSecureTextEntry = textField.isSecureTextEntry
            isEnabled = textField.isEnabled
            isEditing = textField.isEditing
        }

        // Handle UITextView
        else if let textView = view as? UITextView {
            text = textView.text
            if let font = textView.font {
                textSize = Float(font.pointSize)
                fontWeight = font.fontWeight
                fontFamily = font.familyName
            }
            textColor = textView.textColor?.hexString
            textAlignment = getTextAlignment(textView.textAlignment)
            isEnabled = textView.isEditable
            isEditing = textView.isFirstResponder
        }

        // Handle UIImageView
        else if let imageView = view as? UIImageView {
            contentMode = getContentMode(imageView.contentMode)
            imageTintColor = imageView.tintColor?.hexString
            hasImage = imageView.image != nil
            // Note: Cannot get SF Symbol name from UIImage directly
        }

        // Handle UISwitch
        else if let switchView = view as? UISwitch {
            isOn = switchView.isOn
            isEnabled = switchView.isEnabled
        }

        // Handle UISlider
        else if let slider = view as? UISlider {
            value = slider.value
            minValue = slider.minimumValue
            maxValue = slider.maximumValue
            isEnabled = slider.isEnabled
        }

        // Handle UIProgressView
        else if let progressView = view as? UIProgressView {
            progress = progressView.progress
        }

        // Handle UIActivityIndicatorView
        else if let activityIndicator = view as? UIActivityIndicatorView {
            isAnimating = activityIndicator.isAnimating
            isEnabled = !activityIndicator.isHidden
        }

        // Handle UIScrollView and subclasses
        if let scrollView = view as? UIScrollView {
            contentOffset = PointData(point: scrollView.contentOffset)
            contentSize = SizeData(size: scrollView.contentSize)
        }

        // Capture children
        let children = view.subviews.compactMap { subview -> ViewData? in
            if subview.isHidden || subview.alpha < 0.01 {
                return nil
            }
            return captureView(subview, in: screenBounds)
        }

        return ViewData(
            id: UInt(bitPattern: ObjectIdentifier(view)),
            type: type,
            baseType: baseType,
            bounds: bounds,
            backgroundColor: backgroundColor,
            alpha: Float(view.alpha),
            visibility: visibility,
            isHidden: view.isHidden ? true : nil,
            text: text,
            textSize: textSize,
            textColor: textColor,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            textAlignment: textAlignment,
            numberOfLines: numberOfLines,
            lineBreakMode: lineBreakMode,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow,
            clipsToBounds: clipsToBounds,
            masksToBounds: masksToBounds,
            tintColor: tintColor,
            contentMode: contentMode,
            imageTintColor: imageTintColor,
            placeholder: placeholder,
            placeholderColor: placeholderColor,
            isSecureTextEntry: isSecureTextEntry,
            isEnabled: isEnabled,
            isEditing: isEditing,
            isSelected: isSelected,
            isHighlighted: isHighlighted,
            isOn: isOn,
            value: value,
            minValue: minValue,
            maxValue: maxValue,
            progress: progress,
            isAnimating: isAnimating,
            contentOffset: contentOffset,
            contentSize: contentSize,
            hasImage: hasImage,
            imageName: imageName,
            children: children.isEmpty ? nil : children
        )
    }

    private func getVisibility(_ view: UIView) -> String {
        if view.isHidden {
            return "gone"
        } else if view.alpha < 0.01 {
            return "invisible"
        } else {
            return "visible"
        }
    }

    private func getBaseType(_ view: UIView) -> String? {
        if view is UILabel { return "UILabel" }
        if view is UIButton { return "UIButton" }
        if view is UITextField { return "UITextField" }
        if view is UITextView { return "UITextView" }
        if view is UIImageView { return "UIImageView" }
        if view is UISwitch { return "UISwitch" }
        if view is UISlider { return "UISlider" }
        if view is UIProgressView { return "UIProgressView" }
        if view is UIActivityIndicatorView { return "UIActivityIndicatorView" }
        if view is UIScrollView { return "UIScrollView" }
        if view is UITableView { return "UITableView" }
        if view is UICollectionView { return "UICollectionView" }
        if view is UIStackView { return "UIStackView" }
        if view is UINavigationBar { return "UINavigationBar" }
        if view is UITabBar { return "UITabBar" }
        if view is UIToolbar { return "UIToolbar" }
        return nil
    }

    private func getTextAlignment(_ alignment: NSTextAlignment) -> String {
        switch alignment {
        case .left: return "left"
        case .center: return "center"
        case .right: return "right"
        case .justified: return "justify"
        case .natural: return "natural"
        @unknown default: return "left"
        }
    }

    private func getLineBreakMode(_ mode: NSLineBreakMode) -> String {
        switch mode {
        case .byWordWrapping: return "wordWrap"
        case .byCharWrapping: return "charWrap"
        case .byClipping: return "clip"
        case .byTruncatingHead: return "truncateHead"
        case .byTruncatingTail: return "truncateTail"
        case .byTruncatingMiddle: return "truncateMiddle"
        @unknown default: return "wordWrap"
        }
    }

    private func getContentMode(_ mode: UIView.ContentMode?) -> String? {
        guard let mode = mode else { return nil }
        switch mode {
        case .scaleToFill: return "scaleToFill"
        case .scaleAspectFit: return "scaleAspectFit"
        case .scaleAspectFill: return "scaleAspectFill"
        case .redraw: return "redraw"
        case .center: return "center"
        case .top: return "top"
        case .bottom: return "bottom"
        case .left: return "left"
        case .right: return "right"
        case .topLeft: return "topLeft"
        case .topRight: return "topRight"
        case .bottomLeft: return "bottomLeft"
        case .bottomRight: return "bottomRight"
        @unknown default: return nil
        }
    }
}

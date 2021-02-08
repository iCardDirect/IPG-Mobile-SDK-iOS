import Foundation
import UIKit

class ICTextField: UITextField {
    private var bottomLine: CALayer? = nil
    var borderColor: UIColor? = UIColor(hex: "#279BD8FF")
    
    func setupFont(fontType: ICFontType, fontSize: Float) {
        self.font = UIFont(name: appFontName(fontType: fontType), size: CGFloat(fontSize))
    }
    
    func setPlaceHolder(_ placeHolder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                        attributes:
            [
                .font: UIFont(name: appFontName(fontType: .regular), size: CGFloat(14.0))!,
                .foregroundColor: UIColor.gray
        ])
    }
    
    func setRightImage(imageName: String) {
        self.rightViewMode = .always
        
        self.rightView = UIImageView(image: UIImage(named: imageName, in: Bundle.main, compatibleWith: nil))
    }
    
    func showBottomBorder() {
        if let line = bottomLine {
            line.removeFromSuperlayer()
            bottomLine = nil
        }
        bottomLine = CALayer()
        bottomLine!.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine!.backgroundColor = borderColor?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine!)
    }
}

enum ICFontType {
    case light
    case regular
    case extralight
    case regularItalic
    case lightItalic
    case extralightItalic
}

extension UIView {
    func appFontName(fontType: ICFontType) -> String {
        return appFontNameCaros(fontType: fontType)
    }
    
    func appFontNameCaros(fontType: ICFontType) -> String {
        if(fontType == .regular) {
            return "CarosSoft"
        } else if(fontType == .light) {
            return "CarosSoftLight"
        } else if(fontType == .extralight) {
            return "CarosSoftExtraLight"
        } else if(fontType == .regularItalic) {
            return "CarosSoft-Italic"
        } else if(fontType == .lightItalic) {
            return "CarosSoftLight-Italic"
        } else if(fontType == .extralightItalic) {
            return "CarosSoftExtraLight-Italic"
        }
        return ""
    }
    
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

import Foundation
import UIKit

class ICLabel: UILabel {
    
    func setupFont(fontType: ICFontType, fontSize: Float) {
        self.font = UIFont(name: appFontName(fontType: fontType), size: CGFloat(fontSize))
    }
    
}

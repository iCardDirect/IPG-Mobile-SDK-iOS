import Foundation
import UIKit

class ICProductCell: UICollectionViewCell  {
    
    // MARK: Outlets
    @IBOutlet weak var productImageView             : UIImageView!
    @IBOutlet weak var addToCardImageView	        : UIImageView!
    @IBOutlet weak var productPriceLabel            : UILabel!
    @IBOutlet weak var productNameLabel             : UILabel!
    @IBOutlet weak var productDescriptionLabel      : UILabel!
    
    // MARK: Variables
    var addToCartCallback: (() -> Void) = {}
    
    func setup(model: CartItemModel) {
        
        self.productImageView.image = UIImage(named: model.imageName)
        self.productPriceLabel.text = "\(model.currency)\(model.price)"
        self.productPriceLabel.font = UIFont(name: appFontName(fontType: .regular), size: 20)
        
        self.productNameLabel.text = model.title
        self.productNameLabel.font = UIFont(name: appFontName(fontType: .regular), size: 12)
        
        self.productDescriptionLabel.text = model.info
        
        self.addToCardImageView.isUserInteractionEnabled = true
        self.addToCardImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddToCartClicked)))
        
        self.layer.borderColor = UIColor(hex: "#00000029")?.cgColor
        self.layer.borderWidth = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor(hex: "#00000029")?.cgColor
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.cornerRadius  = 4.0
        self.clipsToBounds = true
    }
    
    @objc private func onAddToCartClicked() {
        addToCartCallback()
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = addToCardImageView.hitTest(addToCardImageView.convert(point, from: self), with: event)
        if view == nil {
            view = super.hitTest(point, with: event)
        }

        return view
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event) {
            return true
        }

        return !addToCardImageView.isHidden && addToCardImageView.point(inside: addToCardImageView.convert(point, from: self), with: event)
    }
}

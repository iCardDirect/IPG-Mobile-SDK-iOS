import Foundation


class CartItemModel {
    
    let id: Int64
    let title: String
    let info: String
    let price: Double
    let currency: String
    let imageName: String
    
    init(id: Int64, title: String, info: String, price: Double, currency: String, imageName: String) {
        self.id = id
        self.title = title
        self.info = info
        self.price = price
        self.currency = currency
        self.imageName = imageName
    }
    
}

import Foundation
import UIKit

class OrderTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var titleLabel               : UILabel!
    @IBOutlet private weak var orderIdLabel             : UILabel!
    @IBOutlet private weak var transactionRefLabel      : UILabel!
    @IBOutlet private weak var orderIdvalueLabel        : UILabel!
    @IBOutlet private weak var transactionRefValueLabel : UILabel!
    @IBOutlet private weak var amountLabel              : UILabel!
    @IBOutlet private weak var dateLabel                : UILabel!
    @IBOutlet private weak var timeLabel	            : UILabel!
    
    func setup(orderId: String, transactionReference: String, amount: Double, date: String, time: String) {
        self.titleLabel.text = "purchase".localized()
        self.orderIdLabel.text = "orderIdTxt".localized()
        self.transactionRefLabel.text = "tranRef".localized()
        
        self.orderIdvalueLabel.text = orderId
        self.transactionRefValueLabel.text = transactionReference
        self.amountLabel.text = "\(amount)"
        self.dateLabel.text = date
        self.timeLabel.text = time
        
        let font = UIFont(name: appFontName(fontType: .regular), size: 12)
        let fontLight = UIFont(name: appFontName(fontType: .light), size: 12)
        
        self.orderIdvalueLabel.font = font
        self.titleLabel.font = font
        self.transactionRefLabel.font = fontLight
        self.transactionRefValueLabel.font = font
        self.orderIdLabel.font = fontLight
        self.amountLabel.font = font
        self.dateLabel.font = font
        self.timeLabel.font = font
    }
    
}

import Foundation
import UIKit
import iCardDirectMobileSDK

class RefundViewController: UIViewController {
    
    // MARK: Outlet
    @IBOutlet private weak var transactionReferenceField        : ICTextField!
    @IBOutlet private weak var amountField                      : ICTextField!
    @IBOutlet private weak var orderIdField                     : ICTextField!
    @IBOutlet private weak var saveButton                       : UIButton!
    
    static func instantiate() -> RefundViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RefundViewController") as? RefundViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "refund".localized()
        
        self.orderIdField.setPlaceHolder("orderIdTxt".localized())
        self.amountField.setPlaceHolder("amount".localized())
        self.transactionReferenceField.setPlaceHolder("tranRef".localized())
        
        let grayBorderColor = UIColor(hex: "#707070FF")
        self.orderIdField.borderColor = grayBorderColor
        self.amountField.borderColor = grayBorderColor
        self.transactionReferenceField.borderColor = grayBorderColor
        
        self.orderIdField.showBottomBorder()
        self.amountField.showBottomBorder()
        self.transactionReferenceField.showBottomBorder()
        
        self.orderIdField.setupFont(fontType: .regular, fontSize: 12)
        self.amountField.setupFont(fontType: .regular, fontSize: 12)
        self.transactionReferenceField.setupFont(fontType: .regular, fontSize: 12)
        
        self.saveButton.setTitle("send".localized(), for: .normal)
        let accentColor = UIColor(hex: "#279BD8FF")
        self.saveButton.titleLabel?.font = UIFont(name: view.appFontName(fontType: .regular), size: 17)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.backgroundColor = accentColor
        self.saveButton.layer.cornerRadius = 8.0
        
        self.saveButton.addTarget(self, action: #selector(onSendClicked), for: .touchUpInside)
    }
       
    @objc private func onSendClicked() {
        let orderId = self.orderIdField.text ?? ""
        let amount = self.amountField.text ?? ""
        let tranRef = self.transactionReferenceField.text ?? ""
        
        if orderId.isEmpty || amount.isEmpty || tranRef.isEmpty {
            return
        }
        guard let amountDouble = Double(amount) else {
            return
        }
        
        ICardDirectSDK.shared.refundTransaction(transactionReference: tranRef, amount: amountDouble, orderId: orderId, refundDelegate: self)
    }
}

extension RefundViewController : RefundDelegate {
    func refundSuccess(transactionReference: String, amount: Double, currency: String) {
        self.showMessage(message: "Refund \(transactionReference) \(amount) \(currency)")
    }
    
    func errorWithRefund(status: Int) {
        self.showErrorMessageFromStatusCode(status)
    }
    
    
}

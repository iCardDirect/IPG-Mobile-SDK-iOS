import Foundation
import UIKit
import iCardDirectMobileSDK

class TransactionStatusViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var textField            : ICTextField!
    @IBOutlet private weak var saveButton           : UIButton!
    @IBOutlet private weak var cancelButton         : UIButton!
    
    static func instantiate() -> TransactionStatusViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionStatusViewController") as? TransactionStatusViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.setPlaceHolder("orderIdTxt".localized())
        self.textField.setupFont(fontType: .regular, fontSize: 14)
        self.textField.showBottomBorder()
        
        self.saveButton.setTitle("send".localized().uppercased(), for: .normal)
        self.cancelButton.setTitle("cancel".localized().uppercased(), for: .normal)
        
        self.cancelButton.addTarget(self, action: #selector(onCancelClicked), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(onSendClicked), for: .touchUpInside)
        
        self.cancelButton.titleLabel?.font = UIFont(name: view.appFontName(fontType: .regular), size: 16)
        self.saveButton.titleLabel?.font = UIFont(name: view.appFontName(fontType: .regular), size: 16)
    }
    
    @objc private func onCancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func onSendClicked() {
        let orderId = self.textField.text ?? ""
        if orderId.isEmpty {
            return
        }
        ICardDirectSDK.shared.getTransactionStatus(orderId: orderId, getTransactionStatusDelegate: self)
    }
    
}

extension TransactionStatusViewController : GetTransactionStatusDelegate {
    
    func transactionStatusSuccess(transactionStatus: Int, transactionReference: String) {
        let orderId = self.textField.text ?? ""
        
        let tranType = "\("transactionType".localized())Purchase"
        let orderIdMsg = "\("orderID".localized())\(orderId)"
        let tranStatus = "\("transactionStatus".localized())\n\(transactionStatus)"
        let tranRef = "\("transactionReference".localized())\n\(transactionReference)"
        let message = "\(tranType)\n\(orderIdMsg)\n\(tranStatus)\n\(tranRef)"
        showMessage(message: message)
    }
    
    func errorWithTransactionStatus(status: Int) {
        showMessage(message: "Error \(status)")
    }
    
    
}

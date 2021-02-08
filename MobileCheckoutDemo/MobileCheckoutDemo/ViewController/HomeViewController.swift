import UIKit
import iCardDirectMobileSDK

class HomeViewController: UIViewController {
    
    // MARK Outlets
    @IBOutlet private weak var collectionView                   : UICollectionView!
    @IBOutlet private weak var purchaseButton                   : UIButton!
    @IBOutlet private weak var collectionViewWidthConstraint    : NSLayoutConstraint!
    
    // MARK variables
    private var availableProducts                   : [CartItemModel] = []
    private var cartItems                           : [CartItemModel] = []
    private var currentOrderId                      : String          = ""
    
    // MARK Constants
    private let kCellIdentifier                     : String = "cell"
    private let publicCertificate                   : String =
    "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4ur+fZBqNjnm1XJSJrzf8vyIv" +
    "xfXew44RKJv9kpPiSEtGaRiAmqZhMWsW/fD2Drnh1A6gCgfWIv/3Zgr18GZ/Heqm" +
    "h5n9HmQndHAB2nZnFLOioL9v6awAbqVeqYBMzp97UkruxXDtqejL7w8WkxearqpU" +
    "BBbcPHA2gMp0hRN/MwIDAQAB"
    
    private let privateKey                          : String =
    "MIICXgIBAAKBgQC+NIHevraPmAvx5//z38qjcqlCeyiLwXI5CRNZoL+Ms+/itElM" +
    "ITVpaILCBF5+Uwp+A0pPYy/Gn9S+1gz/LL/mBDbWpTuMhHvEgJilX6CsVIah9/c/" +
    "Bn8U3gT724aBhyIJeKVLO54pILKlkrKId4w76KDaouaFxyCECBMLaXQZoQIDAQAB" +
    "AoGBAI0zVaYSVlzLNzLiU/Srkjc8i8K6wyLc/Pqybhb/arP9cHwP8sn9bTVPTKLT" +
    "s4J8CzH5J1VAANunE7yIEyXsBphnr4lfC0ZPVHavPPBfFR/v9QVI1HByhnjihmG9" +
    "uPZBuUAm/+s20rPOERepEMBmjpHnA7vTefMbtBXhRKbwszYxAkEA3Nl6ZmAIe50y" +
    "yyK3IyCDYitqqQIpMDDTBs8Pn3L+Cen7+a5UXt2+mP87uJSid7m6qK6tQrdKBXgI" +
    "TCMf9DZmBwJBANx6a9liZtQBM+GD0vAMZ3kTcBBKQe/c63pPpDBRSbiIgdhKJzcD" +
    "lfJoGL6wl2QI2NHhXc9eaH6gVGOsBQYD2RcCQQCVYp4Cpa7XPqve7+qE3jdArjGF" +
    "hKqrqDr1/hWJO1VPC3CfoSX8zW1hPDP/VLrY1U7HTvBvkl+Fd33VUmUI4cr9AkAR" +
    "PBSgKpwFKI7oqwhbMW0JPua8r0FWQbu6lO0txbzwiuMziCBmoYYgK9j7VwyOik6A" +
    "oZBWvHeIpnnSTMkbvkNDAkEAvYoCwTJWAGYUDSSLSN+nP1nmrbyJVSSJMNNQ5974" +
    "bBzRvEz9OIgvFL2LslY3kBdwE5JIFacyvDXBVUVqv7MdlQ=="
    let serverUrl                = "https://dev-ipg.icards.eu/sandbox/client/ipgNotify"
    let taxUrl                   = "https://dev-ipg.icards.eu/sandbox/client/ipgTax"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavViewController()

        let sdk = ICardDirectSDK.shared
        
        let themeManager = ThemeManager()
        themeManager.darkMode = false
        themeManager.merchantLogo = UIImage(named: "merchant_logo")
//        themeManager.merchantText = ""
//        themeManager.fontFamily = .caros
//        themeManager.darkMode = false
        sdk.changeThemeManager(themeManager: themeManager)
        
        sdk.initialize(mid: "112", currency: "EUR", clientPrivateKey: privateKey, icardPublicKey: publicCertificate, originator: "33", backendUrl: serverUrl, taxUrl: taxUrl, clientDetails: nil, isSandbox: true)
        sdk.setLanguage(lang: "en")

        
        self.collectionView.register(UINib(nibName: "ICProductCell", bundle: nil), forCellWithReuseIdentifier: kCellIdentifier)
        
        self.availableProducts.append(CartItemModel(id: 1, title: "Run Max Shoes", info: "Some basic description", price: 20.0, currency: "€", imageName: "run_max_shoes"))
        
        self.availableProducts.append(CartItemModel(id: 2, title: "Run Max 4TS", info: "Some basic description", price: 145, currency: "€", imageName: "run_max_4ts"))
        
        self.availableProducts.append(CartItemModel(id: 3, title: "Sport Shoes TTX", info: "Some basic description", price: 510.0, currency: "€", imageName: "sport_shoes_ttx"))
        
        self.availableProducts.append(CartItemModel(id: 4, title: "Sport Shoes XS2", info: "Some basic description", price: 145.0, currency: "€", imageName: "sport_shoes_xs2"))
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.purchaseButton.backgroundColor = UIColor(hex: "#279BD8FF")
        self.purchaseButton.setTitleColor(.white, for: .normal)
        self.purchaseButton.setTitle("pay".localized(), for: .normal)
        self.purchaseButton.isHidden = true
        self.purchaseButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.purchaseButton.layer.cornerRadius = 5
        
        self.purchaseButton.addTarget(self, action: #selector(onPayButtonClicked), for: .touchUpInside)
        
        if UIDevice.current.iPhone5 {
            self.collectionViewWidthConstraint.constant = 300
        }
    }
    
    @objc private func onPayButtonClicked() {
        let cardsSelectionController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let cardsService = CardsService()
        for cardData in cardsService.savedCards() {
            let digits = (cardData[CardsService.kCardPanLastDigits] as? String) ?? ""
            let token = (cardData[CardsService.kCardToken] as? String) ?? ""
            
            let item = UIAlertAction(title: digits, style: .default) { (_) in
                self.onCardSelected(token: token)
            }
            
            cardsSelectionController.addAction(item)
            
        }
        
        let addNewCardAction = UIAlertAction(title: "addNewCard".localized(), style: .default, handler: { (_) in
            self.onCardSelected(token: "")
        })
        addNewCardAction.setValue(UIImage(named: "ic_plus")?.withRenderingMode(.alwaysOriginal), forKey: "image")
        cardsSelectionController.addAction(addNewCardAction)
        
        cardsSelectionController.addAction(UIAlertAction(title: "storeCardAndPurchase".localized(), style: .default, handler: { (_) in
            
            var cardtItemModels = [ICCartItemModel]()
            for cartItem in self.cartItems {
                cardtItemModels.append(ICCartItemModel())
            }
            self.currentOrderId = "\(Int32(Date().timeIntervalSince1970))"
            ICardDirectSDK.shared.storeCardAndPurchase(presentingViewController: self, orderId: self.currentOrderId, cartItems: cardtItemModels, cardStoreDelegate: self)
        }))
        
        cardsSelectionController.addAction(UIAlertAction(title: "cancel".localized(), style: .default, handler: { (_) in
            cardsSelectionController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(cardsSelectionController, animated: true, completion: nil)
    }
    
    private func onCardSelected(token: String) {
        var cardtItemModels = [ICCartItemModel]()
        for cartItem in self.cartItems {
            cardtItemModels.append(ICCartItemModel())
        }

        self.currentOrderId = "\(Int32(Date().timeIntervalSince1970))"

        ICardDirectSDK.shared.purchase(presentingViewController: self, orderId: self.currentOrderId, cardToken: token, cartItems: cardtItemModels, expiryDate: nil, cardHolderName: "Georgi Georgiev", cardCustomName: "Joro",  delegate: self)
    }
    
    private func setupNavViewController() {
        guard let navViewController = self.navigationController else {
            return
        }
        let backgroundColor = UIColor(hex: "#279BD8FF")
        navViewController.navigationBar.backgroundColor = backgroundColor
        navViewController.navigationBar.barTintColor = backgroundColor
        navViewController.navigationBar.tintColor = .white
        navViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navViewController.navigationBar.barStyle = .black
        navViewController.modalPresentationStyle = .overFullScreen
        
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu")?.withTintColor(UIColor.white).withRenderingMode(.alwaysOriginal), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onRightBarButtonItemClicked))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onRightBarButtonItemClicked))
        }
    }

    @objc private func onRightBarButtonItemClicked() {
        self.showOptionsMenu()
    }
    
    private func reloadPurchaseState() {
        self.purchaseButton.isHidden = self.cartItems.isEmpty
    }

    
    func showOptionsMenu() {
        let alertViewController = UIAlertController(title: "", message: "options".localized(), preferredStyle: UIAlertController.Style.actionSheet)
        
        alertViewController.addAction(UIAlertAction(title: "storeNewCard".localized(), style: .default, handler: { (_) in
            
            self.currentOrderId = "\(Int32(Date().timeIntervalSince1970))"
            ICardDirectSDK.shared.storeCard(presentingViewController: self, orderId: self.currentOrderId, storeCardDelegate: self)
        }))
//        alertViewController.addAction(UIAlertAction(title: "updateStoredCard".localized(), style: .default, handler: { (_) in
//            ICardDirectSDK.shared.updateCard(presentingViewController: self, cardToken: "", updateCardDelegate: self)
//        }))
        alertViewController.addAction(UIAlertAction(title: "refund".localized(), style: .default, handler: { (_) in
            if let refundViewController = RefundViewController.instantiate() {
                self.navigationController?.pushViewController(refundViewController, animated: true)
            }
        }))
        alertViewController.addAction(UIAlertAction(title: "transactionStatusTitle".localized(), style: .default, handler: { (_) in
            let alertController = UIAlertController(title: "transactionStatusTitle".localized(), message: "", preferredStyle: .alert)
            var inputView: UITextField? = nil
            alertController.addTextField { (tField) in
                inputView = tField
                tField.placeholder = "orderIdTxt".localized()
            }
            
            alertController.addAction(UIAlertAction(title: "send".localized(), style: .default, handler: { (_) in
                let orderId = inputView?.text ?? ""
                if orderId.isEmpty {
                    return
                }
                ICardDirectSDK.shared.getTransactionStatus(orderId: orderId, getTransactionStatusDelegate: self)
            }))
            
            alertController.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (_) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "orders".localized(), style: .default, handler: { (_) in
            if let ordersViewController = OrdersViewController.instantiate() {
                self.navigationController?.pushViewController(ordersViewController, animated: true)
            }
        }))
        alertViewController.addAction(UIAlertAction(title: "settings".localized(), style: .default, handler: { (_) in
            if let settingsViewController = SettingsViewController.instantiate() {
                self.navigationController?.pushViewController(settingsViewController, animated: true)
            }
        }))
        alertViewController.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: { (_) in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController : ICCheckoutSdkPurchaseDelegate {
    
    func transactionReference(transactionRefModel: ICTransactionRefModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateStr = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = dateFormatter.string(from: Date())
        
        OrdersService().saveNewOrder(orderId: self.currentOrderId, ref: transactionRefModel, date: dateStr, time: timeStr)
        
        let reference = transactionRefModel.transactionReference
        showMessage(message: "purchaseDone".localized() + " \(reference)")
        cartItems.removeAll()
        reloadPurchaseState()
    }
    
    func errorWithTransactionReference(status: Int) {
        self.showErrorMessageFromStatusCode(status)
    }
}

extension HomeViewController : CardStoreDelegate {
    func cardStoredAndPurchaseFinished(storedCardModel: ICStoredCard) {
        let token = storedCardModel.cardToken ?? "-"
        let msg = String(format: "cardStoredAndPurchaseSuccessfully".localized(), token)
        self.showMessage(message: msg)
        CardsService().saveNewCard(card: storedCardModel)
    }
    
    
    func cardStored(storedCardModel: ICStoredCard) {
        let token = storedCardModel.cardToken ?? "-"
        let msg = String(format: "cardStoredSuccessfully".localized(), token)
        self.showMessage(message: msg)
        CardsService().saveNewCard(card: storedCardModel)
    }
    
    func errorWithCardStore(status: Int) {
        self.showErrorMessageFromStatusCode(status)
    }
    
    
}

extension HomeViewController : UICollectionViewDelegate {
    
}

extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.availableProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ICProductCell {
            let product = self.availableProducts[indexPath.row]
            cell.setup(model: product)
            
            cell.addToCartCallback = {
                self.cartItems.append(product)
                self.reloadPurchaseState()
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

//extension HomeViewController : ICCheckoutSdkUpdateCardDelegate {
//    
//    func cardUpdated(storedCardModel: ICStoredCardModel) {
//        self.showMessage(message: "Card update \(storedCardModel.cardToken ?? "-")")
//    }
//    
//    func errorWithCardUpdate(status: Int) {
//        self.showMessage(message: "Error \(status)")
//    }
//    
//    
//}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.iPhone5 {
            return CGSize(width: 140, height: 220)
        }
        let width = self.view.frame.size.width/2 - 30
        let height = width * 1.33
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.iPhone5 {
            return 12
        }
        return 20
    }
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
}

extension UIViewController {
    
    func showMessage(message: String) {
        let alertViewController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "cancel".localized(), style: UIAlertAction.Style.default, handler: { (_) in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        present(alertViewController, animated: true, completion: nil)
    }
    
    func showErrorMessageFromStatusCode(_ code: Int) {
        var msg: String = ""
        guard let sdkStatus = ICOpeartionStatus(rawValue: code) else {
            return
        }
        
        switch sdkStatus {
        case ICOpeartionStatus.completedSuccessfull:
            msg = ""
            break
        case ICOpeartionStatus.technicalIssue:
            msg = "operation_failed_please_contact_us_for_more_details".localized()
            break
        case ICOpeartionStatus.invalidRequest:
            msg = "operation_failed_please_contact_us_for_more_details".localized()
            break
            
        case ICOpeartionStatus.rejectedByPaymentGatewayRiskAssesment:
            msg = "operation_failed_please_contact_us_for_more_details".localized()
            break
            
        case ICOpeartionStatus.rejectedByIssuer:
            msg = "operation_failed_please_contact_your_card_issuer_for_more_details".localized()
            break
            
        case ICOpeartionStatus.statusInsufficientFunds:
            msg = "insufficient_funds_please_contact_your_card_issuer".localized()
            break
            
        case ICOpeartionStatus.rejectedByIssuerRiskAssesment:
            msg = "operation_failed_please_contact_your_card_issuer_for_more_details".localized()
            break
            
        case ICOpeartionStatus.failed3DS:
            msg = "secure_3d_verification_failed".localized()
            break
            
        case ICOpeartionStatus.invalidAmount:
            msg = "invalid_amount_please_try_again_or_contact_your_card_issuer".localized()
            break
            
        case ICOpeartionStatus.threeDSUserInputTimerOut:
            msg = "operation_failed_please_try_again".localized()
            break
            
        case ICOpeartionStatus.noCustomerInputOr3DSResponse:
            msg = "operation_failed_please_try_again".localized()
            break
            
        case ICOpeartionStatus.cancelledByTheCustomerNo3DSResponse:
            msg = "operation_cancelled".localized()
            break
            
        case ICOpeartionStatus.reversed:
            msg = "operation_failed_please_contact_us_for_more_details".localized()
            break
        
        case ICOpeartionStatus.internalError:
            msg = "operation_failed_please_contact_us_for_more_details"
            break
        
        case ICOpeartionStatus.notFound:
            msg = "operation_failed_please_contact_us_for_more_details"
            break
            
        default:
            break
        }
        
        if !msg.isEmpty {
            self.showMessage(message: msg)
        }
        else if sdkStatus != .completedSuccessfull {
            self.showMessage(message: "Error \(code)")
        }
    }
}

extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    var iPhone5: Bool { screenType == .iPhones_5_5s_5c_SE }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        default:
            return .unknown
        }
    }

}


extension String {
    
    private func cardScheme() -> String {
        let pan = self
        if pan.count < 4 {
            return ""
        }
        
        if pan.count == 4 {
            let firstDigit      = Int(pan.substring(to: 1)) ?? 0
            let firstTwoDigits  = Int(pan.substring(to: 2)) ?? 0
            let firstFourDigits = Int(pan) ?? 0
            
            if firstDigit == 4 {
                return "VISA"
            }
            
            if firstDigit == 6 || firstTwoDigits == 50 || (firstTwoDigits >= 56 && firstTwoDigits <= 58) {
                return "MAESTRO"
            }
            
            if (firstTwoDigits >= 51 && firstTwoDigits <= 55) || (firstFourDigits >= 2221  && firstFourDigits <= 2720) {
                return "MASTERCARD"
            }
        }
        return ""
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension HomeViewController : GetTransactionStatusDelegate {
    
    func transactionStatusSuccess(transactionStatus: Int, transactionReference: String) {
        
        let tranType = "\("transactionType".localized())Purchase"
        let tranStatus = "\("transactionStatus".localized())\n\(transactionStatus)"
        let tranRef = "\("transactionReference".localized())\n\(transactionReference)"
        let message = "\(tranType)\n\(tranStatus)\n\(tranRef)"
        showMessage(message: message)
    }
    
    func errorWithTransactionStatus(status: Int) {
        self.showErrorMessageFromStatusCode(status)
    }
    
    
}


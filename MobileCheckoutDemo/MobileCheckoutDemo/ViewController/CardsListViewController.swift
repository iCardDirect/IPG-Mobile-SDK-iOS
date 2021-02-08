import Foundation
import UIKit
import iCardDirectMobileSDK

class CardsListViewController: UIViewController {
    
    // MARK Outlets
    @IBOutlet private weak var tableView                : UITableView!
    @IBOutlet private weak var cancelButton             : UIButton!
    @IBOutlet private weak var addNewCardButton         : UIButton!
    
    
    // MARK Variables
    var callback                                        :((ICStoredCard) -> Void) = { _ in }
    private var cardsService                            : CardsService  = CardsService()
    
    static func instantiate() -> CardsListViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsListViewController") as? CardsListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.setTitle("cancel".localized(), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
        self.cancelButton.titleLabel?.font = UIFont(name: self.view.appFontName(fontType: .regular), size: CGFloat(12.0))
        
        self.addNewCardButton.setTitle("addNewCard".localized(), for: .normal)
        self.addNewCardButton.addTarget(self, action: #selector(onAddNewCard), for: .touchUpInside)
        self.addNewCardButton.titleLabel?.font = UIFont(name: self.view.appFontName(fontType: .regular), size: CGFloat(16.0))
        
        self.tableView.layoutMargins = .zero
        self.tableView.separatorInset = .zero
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc private func onAddNewCard() {
        let icCard = ICStoredCard(status: 0, statusMessage: "", signature: "")
        self.callback(icCard)
        // ICardDirectSDK.shared.storeCard(presentingViewController: self, storeCardDelegate: self)
    }
    
    @objc private func onCancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension CardsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsService.savedCards().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            let card = cardsService.savedCards()[indexPath.row]
            cell.selectionStyle = .none
            let digits = (card[CardsService.kCardPanLastDigits] as? String) ?? ""
            let token = (card[CardsService.kCardToken] as? String) ?? ""
            let msg = "\(token)"
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = msg
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont(name: cell.appFontName(fontType: .regular), size: 14.0)
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension CardsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cardsService.savedCards()[indexPath.row]
        let status = card[CardsService.kStatus] as? Int32 ?? 0
        let statusMessage = card[CardsService.kStatusMessage] as? String ?? ""
        let signature = card[CardsService.kSignature] as? String ?? ""
        let token = card[CardsService.kCardToken] as? String ?? ""
        let cardExpDate = (card[CardsService.kCardExpDate] as? String) ?? ""
    
        
        let icCard = ICStoredCard(status: status, statusMessage: statusMessage, signature: signature)
        icCard.cardToken = token
        icCard.cardExpDate = cardExpDate
        
        self.callback(icCard)
    }
}


//extension CardsListViewController : CardStoreDelegate {
//    func cardStored(storedCardModel: ICStoredCard) {
//        self.callback(storedCardModel)
//    }
//
//    func errorWithCardStore(status: Int) {
//        showMessage(message: "Error \(status)")
//    }
//
//
//}

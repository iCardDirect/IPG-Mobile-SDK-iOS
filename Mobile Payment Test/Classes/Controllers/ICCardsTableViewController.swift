//
//  ICCardsTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import ICCheckout

class ICCardsTableViewController: ICBaseTableViewController {
    
    // MARK: Constants
    
    private let kCellIdentifier = "card"
    
    
    // MARK: Variables
    
    var cartItems: [ICCartItem] = []
    private var orderId: String?
    private var _selectedCardToken: String = ""
    private var _cards: [ICCard] = ICUtils.cards
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        
        if let cardCell = cell as? ICCardTableViewCell {
            cardCell.card = _cards[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.cartItems.count == 0
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cardToDelete = _cards[indexPath.row]
        
        guard let cardIndexToDelete = _cards.index(of: cardToDelete) else {
            return
        }
        
        _cards.remove(at: cardIndexToDelete)
        UserDefaults.deleteCard(cardToDelete)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedCardToken = _cards[indexPath.row].token
        
        self.completePayment()
    }
    
    
    // MARK: Actions
    
    @IBAction func storeCard(_ sender: Any) {
        let controller = ICStoreCardViewController(verificationAmount: 1.00, delegate: self)
        self.presenter.present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: Payment Delegate
    
    override func paymentDidComplete(withReference transactionReference: String) {
        super.paymentDidComplete(withReference: transactionReference)
        
        let transaction = ICTransaction(orderId: self.orderId ?? "", reference: transactionReference)
        UserDefaults.addTransaction(transaction)
    }
    
    
    // MARK: Store Card Delegate
    
    override func storeCardDidComplete(withData storedCard: ICStoredCard) {
        super.storeCardDidComplete(withData: storedCard)
        
        let card = ICCard(name: storedCard.customName, token: storedCard.token)
        UserDefaults.addCard(card)
        
        _cards.append(card)
        self.tableView.insertRows(at: [IndexPath(row: _cards.count - 1, section: 0)], with: .fade)
    }
    
    
    // MARK: Private Methods
    
    func completePayment() {
        let orderId  = ICUtils.randomOrderId
        self.orderId = orderId
        
        UserDefaults.addOrder(orderId)
        
        let controller = ICPaymentViewController(cartItems: self.cartItems,
                                                 orderId: orderId,
                                                 cardToken: _selectedCardToken,
                                                 delegate: self)
        
        self.presenter.present(controller, animated: true, completion: nil)
    }
}

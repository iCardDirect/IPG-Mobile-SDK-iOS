import Foundation
import iCardDirectMobileSDK

class CardsService {
    
    private let kCards      = "app_cards"
    
    static let kCardCustomName     = "cardCustomName"
    static let kCardToken          = "cardToken"
    static let kCardType           = "cardType"
    static let kCardPanLastDigits  = "cardPanLastDigits"
    static let kStatus             = "status"
    static let kCardExpDate        = "cardExpDate"
    static let kStatusMessage      = "statusMessage"
    static let kSignature          = "signature"
    
    func saveNewCard(card: ICStoredCard) {
        var cards = savedCards()
        cards.append(toParameters(card: card))
        self.storeCards(cards: cards)
    }
    
    func savedCards() -> [[String : Any]] {
        let defaults = UserDefaults.standard
        guard let ordersString = defaults.value(forKey: kCards) as? String else {
            return []
        }
        
        if let array = convertToArray(text: ordersString) {
            return array
        }
        return []
    }
    
    private func storeCards(cards: [[String: Any]]) {
        if let stringOrders = toString(dictionary: cards) {
            UserDefaults.standard.set(stringOrders, forKey: kCards)
            UserDefaults.standard.synchronize()
        }
    }
    
    private func convertToArray(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func toString(dictionary: [[String: Any]]) -> String? {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText
        }
        return nil
    }

    private func toParameters(card: ICStoredCard) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params[CardsService.kCardToken] = card.cardToken
        params[CardsService.kCardCustomName] = card.cardCustomName
        params[CardsService.kCardType] = card.cardType
        params[CardsService.kCardPanLastDigits] = card.maskedPan
        params[CardsService.kStatus] = card.status
        params[CardsService.kCardExpDate] = card.cardExpDate
        params[CardsService.kStatusMessage] = card.statusMessage
        params[CardsService.kSignature] = card.signature
            
        return params
    }
    
}

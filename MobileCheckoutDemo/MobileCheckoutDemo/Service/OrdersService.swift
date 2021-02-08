import Foundation
import iCardDirectMobileSDK

class OrdersService {
    private let kOrders                 = "app_orders"
    
    static let kAmount                  = "amount"
    static let kCurrency                = "currency"
    static let kMethod                  = "method"
    static let kSignature               = "signature"
    static let kStatus                  = "status"
    static let kStatusMessage           = "statusMessage"
    static let kTransactionReference    = "transactionReference"
    static let kDate                    = "date"
    static let kTime                    = "time"
    static let kOrderId                 = "orderId"
    
    func saveNewOrder(orderId: String, ref: ICTransactionRefModel, date: String, time: String) {
        var orders = savedOrders()
        var params = toParameters(ref: ref)
        params[OrdersService.kDate] = date
        params[OrdersService.kTime] = time
        params[OrdersService.kOrderId] = orderId
        params[OrdersService.kTransactionReference] = ref.transactionReference
        params[OrdersService.kStatusMessage] = ref.statusMessage
        params[OrdersService.kSignature] = ref.signature
        params[OrdersService.kMethod] = ref.method
        params[OrdersService.kCurrency] = ref.currency
        params[OrdersService.kAmount] = ref.amount
        
        orders.append(params)
        storeOrders(orders: orders)
    }
    
    func savedOrders() -> [[String : Any]] {
        let defaults = UserDefaults.standard
        guard let ordersString = defaults.value(forKey: kOrders) as? String else {
            return []
        }
        
        if let array = convertToArray(text: ordersString) {
            return array.reversed()
        }
        return []
    }
    
    private func storeOrders(orders: [[String: Any]]) {
        if let stringOrders = toString(dictionary: orders) {
            UserDefaults.standard.set(stringOrders, forKey: kOrders)
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

    private func toParameters(ref: ICTransactionRefModel) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params[OrdersService.kAmount] = ref.amount
        params[OrdersService.kCurrency] = ref.currency
        params[OrdersService.kMethod] = ref.method
        params[OrdersService.kSignature] = ref.signature
        params[OrdersService.kStatus] = ref.status
        params[OrdersService.kStatusMessage] = ref.statusMessage
        params[OrdersService.kTransactionReference] = ref.transactionReference
            
        return params
    }
}


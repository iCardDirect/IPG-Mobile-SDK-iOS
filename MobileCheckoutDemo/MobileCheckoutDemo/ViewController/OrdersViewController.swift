import Foundation
import UIKit

class OrdersViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var tableView            : UITableView!
    
    // MARK: Constants
    private let kCell                               : String = "cell"
    private let ordersService                       : OrdersService = OrdersService()
    
    static func instantiate() -> OrdersViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        self.tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: kCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
}

extension OrdersViewController: UITableViewDelegate {
    
}

extension OrdersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersService.savedOrders().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: kCell) as? OrderTableViewCell {
            let orderData = ordersService.savedOrders()[indexPath.row]
            let orderId = orderData[OrdersService.kOrderId] as? String ?? ""
            let transRef = orderData[OrdersService.kTransactionReference] as? String ?? ""
            let amount = orderData[OrdersService.kAmount] as? Double ?? 0.00
            let date = orderData[OrdersService.kDate] as? String ?? ""
            let time = orderData[OrdersService.kTime] as? String ?? ""
            
            cell.setup(orderId: orderId, transactionReference: transRef, amount: amount, date: date, time: time)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    
}

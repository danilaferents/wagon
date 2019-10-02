//
//  CheckOutVC.swift
//  wagon
//
//  Created by Danila Ferents on 25/09/2019.
//  Copyright © 2019 Danila Ferents. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckOutVC: UIViewController {
    
//Outlets
    @IBOutlet weak var tableView: UITableView!
    //Buttons
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var placeOrderBtn: RoundedButton!
    //Labels
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var feeLbl: UILabel!
    @IBOutlet weak var shippingLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    //Activity Indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//Variables
    var paymentContext: STPPaymentContext!
    var paymentOptions: STPPaymentOption!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpPaymentInfo()
        SetUpStripeConfig()
    }
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.trashCell, bundle: nil), forCellReuseIdentifier: Identifiers.trashCell)
    }
    
    func setUpPaymentInfo() {
        subtotalLbl.text = StripeCart.subtotal.penniesToFormattedCurrency()
        feeLbl.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingLbl.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLbl.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func SetUpStripeConfig() {
        //Configuration in payment and shipping onfo required
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .name
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
//        customerContext.retrieveCustomer { (customer, error) in
//            print(error?.localizedDescription)
//        }
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    @IBAction func orderBtnClicked(_ sender: Any) {
        paymentContext.requestPayment()
        
        activityIndicator.startAnimating()
    }
    @IBAction func paymentMethodBtnClicked(_ sender: Any) {
        paymentContext.presentPaymentOptionsViewController()
    }
    @IBAction func shippingMethodBtnClicked(_ sender: Any) {
        paymentContext.presentShippingViewController()
    }
    
}

extension CheckOutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.trashCell, for: indexPath) as? CartItemCell{

            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
                return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

//Remove item from Cart
extension CheckOutVC: CartCellDelegate {
    func productRemoveFromTrash(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setUpPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
    }
}

//For Stripe
extension CheckOutVC: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //Updating the selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        //Updating the selected shipping method
        if let shippingMehod = paymentContext.selectedShippingMethod {
            shippingMethodBtn.setTitle(shippingMehod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMehod.amount) * 100)
            setUpPaymentInfo()
        } else {
            shippingMethodBtn.setTitle("Select Method", for: .normal)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data: [String: Any] = [
            "total" : StripeCart.total,
            "customerId" : userService.user.stripeId,
            "idempotency" : idempotency,
            "mail": userService.user.email,
//            "paymentMethod": paymentOptions.label
        ]
        
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg: "Unable to make charge.")
                completion(STPPaymentStatus.error, error)
                return
            }
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setUpPaymentInfo()
            completion(STPPaymentStatus.success, nil)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "Курьер"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedEx], fedEx)
        } else {
            completion(.invalid, nil, nil, nil)
        }
     }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        activityIndicator.stopAnimating()
        
        switch status {
        case .success:
            title = "Success!"
            message = "Thank you for your purchase."
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .userCancellation:
            return
        @unknown default:
            print("Something went wrong. Unknown case value in didFinishWith!")
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        
        self.present(alertController,animated:  true,completion:  nil)
    }
    
    
}

extension CheckOutVC: STPPaymentOptionsViewControllerDelegate {
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
         self.dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
         self.dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didSelect paymentOption: STPPaymentOption) {
        self.paymentOptions = paymentOption
    }
    
}

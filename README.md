# iCard Mobile Checkout iOS SDK
Accepting mobile payments for merchants

### Table of Contents

* [Security and availability](#security-and-availability)

* [Introduction](#introduction)

* [Integration](#integration)
  
  * [Requirements](#requirements)
  
  * [Setup](#setup)
  
  * [Perform a Payment](#perform-a-payment)
  
  * [Add a Card](#add-a-card)
  
  * [Perform a Payment with stored card](#perform-a-payment-with-stored-card)
  
  * [Perform a Refund](#perform-a-refund)
  
  * [Check transaction status](#check-transaction-status)
  
* [UI customization](#ui-customization)

  * [Hide custom name field](#hide-custom-name-field)
  
  * [Set custom banner](#set-custom-banner)

  * [Configuring displayed colors](#configuring-displayed-colors)
  
  * [Configuring displayed text](#configuring-displayed-text)
  
  
# Security and availability
  
  Connection between Merchant and iCARD is handled through internet using HTTPS protocol (SSL over HTTP). Requests and responses are digitally signed both. iCARD host is located at tier IV datacenter in Luxembourg. The system is designed specifically for the unique challenges of mobile fraud and comes as standard in our SDK. It is powered by the latest machine learning algorithms, as well as trusted methodologies. The SDK comes with built-in checks and security features, including real-time error detection, 3D Secure, data and address validation for frictionless card data capture.
  
  Exchange folder for partners (if needed) is located at a SFTP server which enables encrypted file sharing between parties. The partner receives the account and password for the SFTP directory via fax, email or SMS.
  
  # Introduction
  
  This document describes the methods and interface for mobile checkout. The Merchants should integrate the iCard Mobile Checkout iOS SDK to their mobile apps to accept card payments. The iCard Mobile Checkout iOS SDK will gain access to the entry point of the payment gateway managed by Intercard Finance AD (iCARD). The cardholder will be guided during the payment process and iCARD will check the card sensitive data and will process a payment transaction through card schemes (VISA and MasterCard).
  
  The iCard Mobile Checkout iOS SDK will provide:
  * Secured communication channel with the Merchant
  * Storing of merchant private data (shopping cart, amount, payment methods, transaction details etc.)
  * Financial transactions to VISA, MasterCard вЂ“ transparent for the Merchant
  * Operations for the front-end: Purchase transaction
  * Operations for the back-end: Refund, Void, Payment
  * 3D processing
  * Card Storage

  Out of scope for this document: 
  * Merchant statements and payouts
  * Merchant back-end
  
  The purpose of this document is to specify the iCard Mobile Checkout iOS SDK Interface and demonstrate how it is used in the most common way.
  All techniques used within the interface are standard throughout the industry and should be very easy to implement on any platform.
  
  
  # Integration
  
   A “by appointment” test service is available which allows the validation of the iCard Mobile Checkout iOS SDK calls. Testers   should negotiate an exclusive access to the testing service and ensure monitoring by iCARD engineer.
  
  ## Requirements
  
  * Xcode 
  * iOS device with an OS version of 8.2 or higher

  ## Setup
  
  Start using iCard Mobile Checkout iOS SDK by initializing the setup. Simply fill Originator, MID and secret key provided upon 
  integration and add them to your project. Test settings are ready to use in the test app. Live settings will be kindly provided 
  to you upon integration process.
  
```Swift
...
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  ICCheckout.initialize(withMerchantId: "112",
                          originator: "33",
                          currency: .EUR,
                          certificate: "MIIBkDCB+q ...",
                          privateKey: "MIICXAIBAAKBg ...",
                          bundle: .main,
                          keyIndex: 1,
                          isSandbox: true)
    
    return true
}
...
```

The SDK allows further configuration by using the existing settings. These are the options:
  * Supported card networks – Allows you to determine the accepted card networks when using your app. The default value includes Visa, Visa Electron, MasterCard, Maestro and VPay.
  
  ## Perform a Payment
 
Note: Create an ICPaymentViewController with the required params:

```Swift
  let controller = ICPaymentViewController(cartItems: [], orderId: "1234567890", delegate: self)
  self.present(controller, animated: true, completion: nil)
```
Note: Please make sure that you are using a unique Order ID.

  In your delegate, implement the paymentDidComplete: and paymentDidFailWithError: methods to receive a reference of the payment card, customer ID and transaction reference from Performing a Payment or an error:
  
```Swift
...
func paymentDidComplete(withReference transactionReference: String) {
        
}

func paymentDidFailWithError(_ error: ICCheckoutError) {

}
...
```
  
## Add a Card

Note: Create an ICStoreCardViewController with the required params:

```Swift
let controller = ICStoreCardViewController(verificationAmount: 1.00, delegate: self)
self.present(controller, animated: true, completion: nil)
```
 
 In your delegate, implement the storeCardDidComplete: and storeCardDidFailWithError: methods to receive a card reference for the linked card or an error:
 
 ```Swift
func storeCardDidComplete(withData storedCard: ICStoredCard) {
    
}
    
func storeCardDidFailWithError(_ error: ICCheckoutError) {

}
 ```
 
 ## Perform a Payment with stored card
 
 Create an ICPaymentViewController controller with the required params:
 
```Swift
let controller = ICPaymentViewController(cartItems: [],
                                         orderId: "12345678",
                                         cardToken: "card token",
                                         delegate: self)

self.present(controller, animated: true, completion: nil)
```
Note: Please make sure that you are using a unique Order ID.

In your delegate, implement the paymentDidComplete: and paymentDidFailWithError: methods to receive a reference of the payment card, customer ID and transaction reference from Performing a Payment:

```Swift
...
func paymentDidComplete(withReference transactionReference: String) {
        
}

func paymentDidFailWithError(_ error: ICCheckoutError) {

}
...
```

 ## Perform a Refund

Refunding a payment requires that you have the transactionReference of the payment transaction. Check that you have initialized the SDK before attempting to perform a refund.

```Swift
ICCheckout.refundTransaction(transaction.reference, fromOrder: transaction.orderId, amount: amount, completion: { (transactionRef) in
    
}, failure: { (error) in
    
})
```
Note: Please make sure that you are using the correct Transaction Reference ID for the transaction that you want to be refunded.

 ## Check transaction status
 
 You can choose between the transaction types of Purchase or Refund and to send the order ID of which transaction status needed to be checked. The method will retrieve the transaction status and the transaction reference:
 
```Swift
ICCheckout.getOrderStatus(orderId,
                          transactionType: type,
                          completion: { (status, reference) in
                          
},
                          failure: { (error) in
                          
})
```

# UI customization

Use iCard Mobile Checkout iOS SDK UI components for a frictionless checkout in your app. Minimize your PCI scope with a UI that can be themed to match your brand colors.

Built-in features include quick data entry, optional security checks and fraud prevention that let you focus on developing other areas of your app.

The iCard Mobile Checkout iOS SDK supports a range of UI customization options to allow you to match payment screen appearance to your app's branding.

## Configuring theme

Create a new ICCheckoutTheme object and specify the following:

Note: Those are the default theme settings

```Swift
let theme                  = ICCheckoutTheme()
theme.labelFontSize        = 13.0
theme.placeholderFontSize  = 13.0
theme.textFieldBorderColor = UIColor.gray.withAlphaComponent(0.3)
theme.placeholderAlignment = .left
theme.textFieldFont        = UIFont.systemFont(ofSize: 14.0)
theme.labelTextColor       = .defaultTextColor
theme.placeholderColor     = .lightGrayColor
theme.barButtonItemColor   = .buttonEnabled
theme.textFieldTextColor   = .defaultTextColor
theme.navigationTitleColor = .defaultTextColor
```


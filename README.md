# iCard Mobile Checkout iOS SDK
Accepting mobile payments for merchants

### Table of Contents

* [Security and availability](#security-and-availability)

* [Introduction](#introduction)

* [Integration](#integration)
  
  * [Requirements](#requirements)
  
  * [Setup](#setup)
  
  * [Make a payment with a new or already stored card](#make-a-payment-with-a-new-or-already-stored-card)
  
  * [Make a payment and store card](#make-a-payment-and-store-card)
  
  * [Add a Card](#add-a-card)
 
  * [Perform a Refund](#perform-a-refund)
  
  * [Check transaction status](#check-transaction-status)
  
* [UI customization](#ui-customization)

* [Enumerators](#enumerators)
  
# Security and availability
  
  Connection between Merchant and iCARD is handled through internet using HTTPS protocol (SSL over HTTP). Requests and responses are digitally signed both. iCARD host is located at tier IV datacenter in Luxembourg. The system is designed specifically for the unique challenges of mobile fraud and comes as standard in our SDK. It is powered by the latest machine learning algorithms, as well as trusted methodologies. The SDK comes with built-in checks and security features, including real-time error detection, 3D Secure, data and address validation for frictionless card data capture.
  
  Exchange folder for partners (if needed) is located at a SFTP server which enables encrypted file sharing between parties. The partner receives the account and password for the SFTP directory via fax, email or SMS.
  
  # Introduction
  
  This document describes the methods and interface for mobile checkout. The Merchants should integrate the iCard Mobile Checkout iOS SDK to their mobile apps to accept card payments. The iCard Mobile Checkout iOS SDK will gain access to the entry point of the payment gateway managed by Intercard Finance AD (iCARD). The cardholder will be guided during the payment process and iCARD will check the card sensitive data and will process a payment transaction through card schemes (VISA and MasterCard).
  
  The iCard Mobile Checkout iOS SDK will provide:
  * Secured communication channel with the Merchant
  * Storing of merchant private data (shopping cart, amount, payment methods, transaction details etc.)
  * Financial transactions to VISA, MasterCard transparent for the Merchant
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
  * iOS device with an OS version of 11.0 or higher

  ## Setup
  
  Start using iCard Mobile Checkout iOS SDK by initializing the setup. Simply fill Originator, MID and secret key provided upon 
  integration and add them to your project. Test settings are ready to use in the test app. Live settings will be kindly provided 
  to you upon integration process.
  
  1. Add following code into the Mobile App podfile and run pod install:
    
   ```Swift
      pod 'iCardDirectMobileSDK', :podspec => 'https://icard.com/iCardDirectSdk/1.0.5/iCardDirectMobileSDK'
   ```
  
  ## Initialization
  
```Swift
    let sdk = ICardDirectSDK.shared
    
    let clDetails                       = ICClientDetails()
    clDetails.name                      = ""
    clDetails.billingAddress            = ""
    clDetails.billingAddressCity        = ""
    clDetails.billingAddressCountry     = ""
    clDetails.emailAddress              = ""
    clDetails.billingAddressPostCode    = ""
    clDetails.customerIdentifier        = ""
    
    sdk.initialize(    
                        mid               :"112",             
                        currency          : "EUR",              
                        clientPrivateKey  : "MIIBkDCB+q ..",    
                        icardPublicKey    : "MIICXAIBAAKBg..",  
                        originator        : "33",
                        backendUrl        : "https://callback.url/",
                        taxUrl            : "",
                        language          : "en",   // Available languages en, bg, de, es, it, nl, ro. Translation is managed by SDK.
                        clientDetailes    : clDetails,
                        keyIndex          : 1,      
                        isSandbox         : true)
    
```
 
 Additional information:

  * At backendUrl you will be notified about payment status after completion. In body of your HTTP response you should include only the string OK. Otherwise, we will decline the transaction and will generate a reversal. After each method you will find parameters, which you will receive at the backendUrl. For more information about signature verification please visit our documentation [here](https://icard.direct/documents/IPG_API_v3.4_22.pdf).
  
  ## Make a payment with a new or already stored card
   
```Swift
ICardDirectSDK.shared.purchase(  
                        presentingViewController  : viewController, 
                        orderId                   : orderId,  
                        cardToken                 : "",         // optional if you pay with stored card
                        cartItems                 : [cartItem],
                        expiryDate                : "12/22",
                        cardHolderName            : "", 
                        cardCustomName            : "", 
                        delegate                  : delegate)
```

Delegate should implement the following protocol:

```Swift
public protocol ICCheckoutSdkPurchaseDelegate {
  func transactionReference(transactionRefModel: ICTransactionRefModel)
  func errorWithTransactionReference(status: Int)
}
```
Note: Please make sure that you are using a unique Order ID.

   ### Below are the POST parameters that you will receive at provided backendUrl:

#### On success:
```Swift
    IPGmethod       => IPGPurchaseNotify  
    MID             => '000000000000123'
    OrderID         => '1854'
    Amount          => '23.45'
    Currency        => '978'
    CustomerIP      => '82.119.81.30'
    CardType        => 'MasterCard'
    Pan             => '4567'
    ExpdtYYMM       => '2112'
    Approval        => 'MSQI258'
    IPG_Trnref      => '20210716141055303234'
    RequestSTAN     => '349875'
    RequestDateTime => '2021-07-16 14:10:55'
    Signature       => 'kcBs8LoJkXZlclhpykaWIx............'
 ```
 
#### On failure:
```Swift
    IPGmethod       => IPGPurchaseRollback
    MID             => '000000000000123'
    OrderID         => '1854'
    Amount          => '23.45'
    Currency        => '978'
    CustomerIP      => '82.119.81.30'
    Signature       => 'kcBs8LoJkXZlclhpykaWIx............'
 ```
 
## Make a payment and store card
```Swift
ICardDirectSDK.shared.storeCardAndPurchase(
                          presentingViewController  : viewController,
                          orderId                   : orderId,
                          cartItems                 : [cartItem],
                          cardStoreDelegate         : delegate)
```

Delegate should implement the following protocol:

```Swift
public protocol CardStoreDelegate {
    func cardStored(storedCardModel: ICStoredCard)  // If is used for storeCard
    func errorWithCardStore(status: Int)
    func cardStoredAndPurchaseFinished(storedCardModel: ICStoredCard) // If is used for storeCardAndPurchase
}
```

Note: Please make sure that you are using a unique Order ID.

### Below are the POST parameters that you will receive at provided backendUrl:

#### On success:
```Swift
   IPGmethod       => IPGStoreCardNotify
   MID             => '000000000000123'
   OrderID         => '1854'
   Amount          => '23.45'
   Currency        => '978'
   CustomerIP      => '82.119.81.30'
   Token           => 'D747458899D….FC43D5'
   Cardholder Name => 'Dimitar Dimitrov'
   CardType        => 'MasterCard'
   Custom Name     => 'My VISA card from iCard'
   Pan             => '4567'
   Approval        => 'MSQI258'
   IPG_Trnref      => '20210716141055303234'
   RequestSTAN     => '349875'
   RequestDateTime => '2021-07-16 14:10:55'
   Signature       => 'kcBs8LoJkXZlclhpykaWIx............'
 ```
 
#### On failure:
```Swift
   IPGmethod       => IPGPurchaseRollback
   MID             => '000000000000123'
   OrderID         => '1854'
   Amount          => '23.45'
   Currency        => '978'
   CustomerIP      => '82.119.81.30'
   Signature       => 'kcBs8LoJkXZlclhpykaWIx............'
```

## Add a Card

```Swift
ICardDirectSDK.shared.storeCard(
                        presentingViewController  : viewController, 
                        orderId                   : orderId, 
                        storeCardDelegate         : delegate)
```
 
Delegate should implement the following protocol:
 
 ```Swift
public protocol CardStoreDelegate {
  func cardStored(storedCardModel: ICStoredCard) // If is used for storeCard
  func errorWithCardStore(status: Int)
  func cardStoredAndPurchaseFinished(storedCardModel: ICStoredCard) // If is used for storeCardAndPurchase
}
```

Note: Please make sure that you are using a unique Order ID. 

### Below are the POST parameters that you will receive at provided backendUrl:

#### On success:
```Swift
   IPGmethod       => IPGStoreCardNotify
   MID             => '000000000000123'
   OrderID         => '1854'
   Amount          => '23.45'
   Currency        => '978'
   CustomerIP      => '82.119.81.30'
   Token           => 'D747458899D….FC43D5'
   Cardholder Name => 'Dimitar Dimitrov'
   CardType        => 'MasterCard'
   Custom Name     => 'My VISA card from iCard'
   Pan             => '4567'
   Approval        => 'MSQI258'
   IPG_Trnref      => '20210716141055303234'
   RequestSTAN     => '349875'
   RequestDateTime => '2021-07-16 14:10:55'
   Signature       => 'kcBs8LoJkXZlclhpykaWIx............'
```

#### On failure:
```Swift
   IPGmethod       => IPGPurchaseRollback
   MID             => '000000000000123'
   OrderID         => '1854'
   Amount          => '23.45'
   Currency        => '978'
   CustomerIP      => '82.119.81.30'
   Signature       => 'kcBs8LoJkXZlclhpykaWIx............'
```

## Perform a Refund

Refunding a payment requires that you have the transactionReference of the payment transaction. Check that you have initialized the SDK before attempting to perform a refund.

```Swift
ICardDirectSDK.shared.refundTransaction(  
                        transactionReference  : String,
                        amount                : Double,
                        orderId               : String,
                        refundDelegate        : delegate) /* implementation of the RefundDelegate protocol */
```

Delegate should implement the following protocol:

```Swift
public protocol RefundDelegate {
    func refundSuccess(transactionReference: String, amount: Double, currency: String)
    func errorWithRefund(status: Int)
}
```

Note: Please make sure that you are using the correct Transaction Reference ID for the transaction that you want to be refunded.

 ## Check transaction status
 
 You can choose between transaction types of Purchase or Refund and send the order ID of the transaction that need to be checked. The method will retrieve the transaction status and the transaction reference:
 
```Swift
ICardDirectSDK.shared.getTransactionStatus( 
                          orderId                       : String,
                          getTransactionStatusDelegate  : delegate)
```

Delegate should implement the following protocol:

```Swift
public protocol GetTransactionStatusDelegate {
    func transactionStatusSuccess(transactionStatus: Int, transactionReference: String)
    func errorWithTransactionStatus(status: Int)
}
```

# UI customization

Use iCard Mobile Checkout iOS SDK UI components for a frictionless checkout in your app. Minimize your PCI scope with an UI that can be themed to match your brand colors.

The iCard Mobile Checkout iOS SDK supports a range of UI customization options to allow you to match payment screen appearance to your app's branding.

```Swift
let themeManager              = ThemeManager()
themeManager.darkMode         = false
themeManager.merchantText     = ""
themeManager.fontFamily       = .caros
themeManager.darkMode         = false
themeManager.toolbarTextColor = .white
themeManager.buttonTextColor  = .white
themeManager.fontFamily       = ICFontFamily.caros
sdk.changeThemeManager(themeManager: themeManager)
```

 ## Enumerators
 
 Operation statuses :
  
```Swift
ICOpeartionStatus.completedSuccessfull                  
ICOpeartionStatus.technicalIssue                        
ICOpeartionStatus.invalidRequest                        
ICOpeartionStatus.rejectedByPaymentGatewayRiskAssesment 
ICOpeartionStatus.rejectedByIssuer                      
ICOpeartionStatus.statusInsufficientFunds               
ICOpeartionStatus. rejectedByIssuerRiskAssesment        
ICOpeartionStatus.invalidCard                           
ICOpeartionStatus.invalidAmount                         
ICOpeartionStatus.failed3DS                             
ICOpeartionStatus.threeDSUserInputTimerOut              
ICOpeartionStatus.noCustomerInputOr3DSResponse          
ICOpeartionStatus.cancelledByTheCustomerNo3DSResponse   
ICOpeartionStatus.reversed                              
ICOpeartionStatus.internalError                         
ICOpeartionStatus.notFound                              
```

Card types :

```Swift
ICCardType.cardTypeMastercard      
ICCardType.cardTypeMaestro         
ICCardType.cardTypeVisa            
ICCardType.cardTypeElectron        
ICCardType.cardTypeVpay            
ICCardType.cardTypeJcb             
ICCardType.cardTypeBanContact      
ICCardType.cardTypeAmericanExpress 
ICCardType.cardTypeUnionPay        
```

Fonts :

```Swift
ICFontFamily.caros
ICFontFamily.lato
ICFontFamily.montseratt
ICFontFamily.opensans
ICFontFamily.raleway
ICFontFamily.roboto
ICFontFamily.robotoSlab
ICFontFamily.sfProDisplay
```

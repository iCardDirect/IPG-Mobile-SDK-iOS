//
//  ICCheckoutError.h
//  ICCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ICCheckoutError : NSError

+ (instancetype)errorWithStatus:(NSInteger)status;
+ (instancetype)notInitializedError;
+ (instancetype)communicationError;
+ (instancetype)undefinedError;

@end

extern NSInteger const ICCheckoutConnectivityChangedError;
extern NSInteger const ICCheckoutNotInitializedError;
extern NSInteger const ICCheckoutSignatureValidationError;
extern NSInteger const ICCheckoutCommunicationError;
extern NSInteger const ICCheckoutInvalidInputParametersError;
extern NSInteger const ICCheckoutAPIError;
extern NSInteger const ICCheckoutTimeoutError;
extern NSInteger const ICCheckoutNoError;
extern NSInteger const ICCheckoutInvalidMerchantIdError;
extern NSInteger const ICCheckoutInvalidParametersError;
extern NSInteger const ICCheckoutInvalidAmountError;
extern NSInteger const ICCheckoutInsufficientFundsError;
extern NSInteger const ICCheckoutTransactionNotPermittedError;
extern NSInteger const ICCheckoutLimitExceededError;
extern NSInteger const ICCheckoutInactiveAccountError;
extern NSInteger const ICCheckoutInvalidAccountError;
extern NSInteger const ICCheckoutAccountLimitExceededError;
extern NSInteger const ICCheckoutOrderIdAlreadyUsedError;
extern NSInteger const ICCheckoutDeclinedByCardIssuerError;
extern NSInteger const ICCheckoutUndefinedError;

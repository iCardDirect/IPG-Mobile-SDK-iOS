//
//  ICCheckout.h
//  ICCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ICCard.h"
#import "ICStoredCard.h"
#import "ICCartItem.h"
#import "ICCheckoutTheme.h"
#import "ICCheckoutError.h"
#import "ICCheckoutProtocols.h"
#import "ICPaymentViewController.h"
#import "ICStoreCardViewController.h"

typedef NS_ENUM (NSUInteger, ICTransactionType) {
    ICTransactionTypeUnknown,
    ICTransactionTypePurchase,
    ICTransactionTypeRefund,
};

typedef NS_ENUM (NSUInteger, ICCurrency) {
    ICCurrencyUSD,
    ICCurrencyBGN,
    ICCurrencyEUR
};

@interface ICCheckout : NSObject

+ (void)initializeWithMerchantId:(NSString * _Nonnull)merchantId
                      originator:(NSString * _Nonnull)originator
                        currency:(ICCurrency)currency
                     certificate:(NSString * _Nonnull)certificate
                      privateKey:(NSString * _Nonnull)privateKey
                          bundle:(NSBundle * _Nullable)bundle
                        keyIndex:(NSInteger)keyIndex;

+ (void)initializeWithMerchantId:(NSString * _Nonnull)merchantId
                      originator:(NSString * _Nonnull)originator
                        currency:(ICCurrency)currency
                     certificate:(NSString * _Nonnull)certificate
                      privateKey:(NSString * _Nonnull)privateKey
                          bundle:(NSBundle * _Nullable)bundle
                        keyIndex:(NSInteger)keyIndex
                       isSandbox:(BOOL)isSandbox;

+ (void)applyTheme:(ICCheckoutTheme * _Nonnull)theme;

+ (void)getOrderStatus:(NSString * _Nonnull)orderId
       transactionType:(ICTransactionType)transactionType
            completion:(void (^ _Nullable)(NSInteger status, NSString * _Nonnull transactionRef))completion
               failure:(void (^ _Nullable)(ICCheckoutError * _Nonnull error))failure;

+ (void)refundTransaction:(NSString * _Nonnull)transactionRef
                fromOrder:(NSString * _Nonnull)orderId
                   amount:(CGFloat)amount
               completion:(void (^ _Nullable)(NSString * _Nonnull transactionRef))completion
                  failure:(void (^ _Nullable)(ICCheckoutError * _Nonnull error))failure;

@end

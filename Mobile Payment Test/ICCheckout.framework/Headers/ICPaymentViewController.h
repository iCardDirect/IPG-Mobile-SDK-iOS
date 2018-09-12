//
//  ICPaymentViewController.h
//  ICCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICCartItem.h"
#import "ICCheckoutController.h"
#import "ICCheckoutProtocols.h"

@interface ICPaymentViewController : ICCheckoutController

/*!
 * @method initWithCartItems:orderId:delegate:
 *
 * @param cartItems An array of CartItem objects.
 * @param orderId   A custom order id for reference.
 * @param delegate  A delegate to implement the PaymentDelegate protocol methods.
 *
 * @see             CartItem
 * @seealso         PaymentDelegate
 */
- (nonnull instancetype)initWithCartItems:(nonnull NSArray<ICCartItem *> *)cartItems
                                  orderId:(nonnull NSString *)orderId
                                 delegate:(nullable id<ICPaymentDelegate>)delegate;

/*!
 * @method initWithCartItems:orderId:cardToken:delegate:
 *
 * @param cartItems An array of CartItem objects.
 * @param orderId   A custom order id for reference.
 * @param cardToken The token of the stored card.
 * @param delegate  A delegate to implement the PaymentDelegate protocol methods.
 *
 * @see             CartItem
 * @seealso         PaymentDelegate
 */
- (nonnull instancetype)initWithCartItems:(nonnull NSArray<ICCartItem *> *)cartItems
                                  orderId:(nonnull NSString *)orderId
                                cardToken:(nonnull NSString *)cardToken
                                 delegate:(nullable id<ICPaymentDelegate>)delegate;

@end

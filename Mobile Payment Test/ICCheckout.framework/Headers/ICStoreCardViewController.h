//
//  ICStoreCardViewController.h
//  ICCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICCheckoutController.h"
#import "ICCheckoutProtocols.h"

@interface ICStoreCardViewController : ICCheckoutController

/*!
 * @method initWithVerificationAmount:delegate:
 *
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithVerificationAmount:(CGFloat)verificationAmount
                                          delegate:(nullable id<ICStoreCardDelegate>)delegate;

/*!
 * @method initWithVerificationAmount:delegate:
 *
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 * @param withoutCustomName     An optional parameter whether to hide a field for custom card name Default is NO.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithVerificationAmount:(CGFloat)verificationAmount
                                          delegate:(nullable id<ICStoreCardDelegate>)delegate
                                 withoutCustomName:(BOOL)withoutCustomName;

@end

//
//  ICPaymentDelegate.h
//  ICCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICCheckoutError.h"
#import "ICStoredCard.h"

@protocol ICPaymentDelegate <NSObject>

/*!
 * @method paymentDidCompleteWithReference:
 *
 * @param transactionReference  The reference of the successfull transaction.
 */
- (void)paymentDidCompleteWithReference:(nonnull NSString *)transactionReference;

/*!
 * @method paymentDidFailWithError:
 *
 * @param error Information about an error that occured during a payment.
 */
- (void)paymentDidFailWithError:(nonnull ICCheckoutError *)error;

@end

@protocol ICStoreCardDelegate <NSObject>

/*!
 * @method storeCardDidCompleteWithData:
 *
 * @param storedCard The stored card with all it's data.
 */
- (void)storeCardDidCompleteWithData:(nonnull ICStoredCard *)storedCard;

/*!
 * @method storeCardDidFailWithError:
 *
 * @param error Information about an error that occured while storing a card.
 */
- (void)storeCardDidFailWithError:(nonnull ICCheckoutError *)error;

/*!
 * @method updateStoredCardDidCompleteWithData:forCardWithName:
 *
 * @param storedCard The updared stored card with all it's data.
 * @param cardToken  The old token of the successfully updated stored card.
 */
- (void)updateStoredCardDidCompleteWithData:(nonnull ICStoredCard *)storedCard forCardWithToken:(nonnull NSString *)cardToken;

/*!
 * @method updateStoredCardDidFailWithError:
 *
 * @param error Information about an error that occured while updating a stored card.
 */
- (void)updateStoredCardDidFailWithError:(nonnull ICCheckoutError *)error;

@end

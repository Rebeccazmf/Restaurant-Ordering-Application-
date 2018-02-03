//
//  OrderItem.h
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject
@property NSString *orderItemName;
@property NSString *orderItemPrice;
@property NSString *orderItemDescription;
-(id)initWithItemName:(NSString *) itemName
            itemPrice:(NSString *) itemPrice
      itemDescription:(NSString *) itemDescription;

@end

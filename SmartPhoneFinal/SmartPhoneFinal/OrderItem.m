//
//  OrderItem.m
//  SmartPhoneFinal
//
//  Created by Mengfei on 4/14/17.
//  Copyright © 2017 Mengfei. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

-(id)initWithItemName:(NSString *) itemName
            itemPrice:(NSString *) itemPrice
      itemDescription:(NSString *) itemDescription

// photoPath:(NSString *) photoPath;
{
    self = [super init];
    if (self) {
        _orderItemName = itemName;
        _orderItemPrice = itemPrice;
        _orderItemDescription = itemDescription;
        // _photoPath = photoPath;
    }
    return self;
}
@end

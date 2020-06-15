//
//  Category.m
//  MyTube
//
//  Created by 김학철 on 2020/06/15.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id)initWithSnapShot:(FIRDataSnapshot *)snapshot {
    if (self = [super init]) {
        self.key = snapshot.key;
        
        NSDictionary *valueInfo = snapshot.value;
        self.category = [valueInfo objectForKey:@"category"];
        self.titleEn = [[valueInfo objectForKey:@"titleInfo"] objectForKey:@"en"];
        self.titleKo = [[valueInfo objectForKey:@"titleInfo"] objectForKey:@"ko"];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *des = [NSMutableString string];
    [des appendFormat:@"key = %@\r",_key];
    [des appendFormat:@"category = %@\r",_category];
    [des appendFormat:@"titleEn = %@\r",_titleEn];
    [des appendFormat:@"titleKo = %@\r",_titleKo];
    return des;
}
@end

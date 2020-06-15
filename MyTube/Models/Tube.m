//
//  Tube.m
//  MyTube
//
//  Created by 김학철 on 2020/06/15.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "Tube.h"

@implementation Tube
- (id)initWithSnapShot:(FIRDataSnapshot *)snapshot {
    if (self = [super init]) {
        self.key = snapshot.key;
        NSDictionary *valueInfo = snapshot.value;
        self.thumbnailUrl = [valueInfo objectForKey:@"thumbnail"];
        self.youtubeId = [valueInfo objectForKey:@"youtubeId"];
        self.videoUrl = [valueInfo objectForKey:@"videoUrl"];
        self.title = [valueInfo objectForKey:@"title"];
        self.videoLenght = [[valueInfo objectForKey:@"videoLength"] floatValue];
    }
    
    return self;
}

- (NSString *)description {
    NSMutableString *des = [NSMutableString string];
    [des appendFormat:@"key = %@\r" ,_key];
    [des appendFormat:@"thumbnailUrl = %@\r" ,_thumbnailUrl];
    [des appendFormat:@"titleInfo = %@\r" ,_title];
    [des appendFormat:@"videoUrl = %@\r" ,_videoUrl];
    [des appendFormat:@"youtubeId = %@\r" ,_youtubeId];
    [des appendFormat:@"youtubeId = %f\r" ,_videoLenght];
    return des;
}
@end

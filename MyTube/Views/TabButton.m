//
//  TabButton.m
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "TabButton.h"
@interface TabButton ()
@property (nonatomic, strong) CALayer *underlineLayer;
@end
@implementation TabButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_underlineLayer) {
        [_underlineLayer removeFromSuperlayer];
    }
    self.underlineLayer = [[CALayer alloc] init];
    _underlineLayer.frame = CGRectMake(0, self.frame.size.height - _underLineWidth, self.frame.size.width, _underLineWidth);
    
    if (self.selected) {
        if (_colorSelect != nil) {
            _underlineLayer.backgroundColor = _colorSelect.CGColor;
        }
    }
    else {
        if (_colorNormal != nil) {
            _underlineLayer.backgroundColor = _colorNormal.CGColor;
        }
    }
    
    [self.layer addSublayer:_underlineLayer];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

@end

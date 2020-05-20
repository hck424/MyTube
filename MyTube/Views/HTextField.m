//
//  HTextField.m
//  Hanpass
//
//  Created by 김학철 on 29/09/2019.
//  Copyright © 2019 hanpass. All rights reserved.
//

#import "HTextField.h"
#define DEFAULT_BORDER_COLOR RGB(153, 153, 153)
#define DEFAULT_PLACE_HOLDER_COLOR RGB(153, 153, 153)

@interface HTextField ()
@property (nonatomic, strong) CALayer *subLayer;
@end
@implementation HTextField

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)deleteBackward {
    [super deleteBackward];
    if ([_myDelegate respondsToSelector:@selector(textFieldDidDelete:)]) {
        [_myDelegate textFieldDidDelete:self];
    }
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.borderStyle = UITextBorderStyleNone;
    
    if (_borderWidth == 0) {
        _borderWidth = 1.0;
    }
    if (_borderColor == nil) {
        _borderColor = DEFAULT_BORDER_COLOR;
    }
    
    if (_borderBottom) {
        if (_subLayer) {
            [_subLayer removeFromSuperlayer];
        }
        self.subLayer = [CALayer layer];
        _subLayer.backgroundColor = _borderColor.CGColor;
        _subLayer.frame = CGRectMake(0, self.frame.size.height - _borderWidth, self.frame.size.width, _borderWidth);
        
       [self.layer addSublayer:_subLayer];
       self.layer.masksToBounds = YES;
    }
    else if (_borderAll) {
        self.layer.borderWidth = _borderWidth;
        self.layer.borderColor = _borderColor.CGColor;
        
        if (_cornerRadius > 0) {
            self.layer.cornerRadius = _cornerRadius;
            self.layer.masksToBounds = YES;
        }
    }
    
    if (_localizablePlaceHolder.length > 0) {
        if (_colorPlaceHolder == nil) {
            _colorPlaceHolder = DEFAULT_PLACE_HOLDER_COLOR;
        }
        UIFont *font = self.font;
        if (_isFontSizePlaceHolder == NO) {
            font = [UIFont systemFontOfSize:self.font.pointSize weight:UIFontWeightRegular];
        }
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(_localizablePlaceHolder, @"") attributes:@{NSForegroundColorAttributeName: _colorPlaceHolder, NSFontAttributeName : font}];
        
        self.attributedPlaceholder = attr;
    }
}

// ibdesinable setter
- (void)setBorderBottom:(BOOL)borderBottom {
    _borderBottom = borderBottom;
    [self setNeedsDisplay];
}
- (void)setBorderAll:(BOOL)borderAll {
    _borderAll = borderAll;
    [self setNeedsDisplay];
}
- (void)setLocalizablePlaceHolder:(NSString *)localizablePlaceHolder {
    _localizablePlaceHolder = localizablePlaceHolder;
    [self setNeedsDisplay];
}
- (void)setColorPlaceHolder:(UIColor *)colorPlaceHolder {
    _colorPlaceHolder = colorPlaceHolder;
    [self setNeedsDisplay];
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsDisplay];
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}
- (void)setIsFontSizePlaceHolder:(BOOL)isFontSizePlaceHolder {
    _isFontSizePlaceHolder = isFontSizePlaceHolder;
    [self setNeedsDisplay];
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight));
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight));
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if (action == @selector(paste:))
//        return NO;
//    return [super canPerformAction:action withSender:sender];
    return [super canPerformAction:action withSender:sender];
}
@end

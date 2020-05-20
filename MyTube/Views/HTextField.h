//
//  HTextField.h
//  Hanpass
//
//  Created by 김학철 on 29/09/2019.
//  Copyright © 2019 hanpass. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTextFieldDelegate <NSObject>
@optional
- (void)textFieldDidDelete:(id)textField;
@end

@interface HTextField : UITextField
@property (nonatomic, assign) IBInspectable CGFloat insetTop;
@property (nonatomic, assign) IBInspectable CGFloat insetLeft;
@property (nonatomic, assign) IBInspectable CGFloat insetBottom;
@property (nonatomic, assign) IBInspectable CGFloat insetRight;

@property (nonatomic, strong) IBInspectable NSString *localizablePlaceHolder;
@property (nonatomic, strong) IBInspectable UIColor *colorPlaceHolder;
@property (nonatomic, assign) IBInspectable BOOL isFontSizePlaceHolder;
@property (nonatomic, assign) IBInspectable BOOL borderBottom;
@property (nonatomic, assign) IBInspectable BOOL borderAll;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, strong) id data;
@property (nonatomic, weak) id<HTextFieldDelegate>myDelegate;
@end


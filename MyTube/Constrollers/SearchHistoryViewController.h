//
//  SearchHistoryViewController.h
//  MyTube
//
//  Created by 김학철 on 2020/05/28.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTextField.h"
#import "Search+CoreDataProperties.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CellTypeNorMal,
    CellTypeEdit
} CellType;

@interface SearchHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (nonatomic, copy) void (^onClickedTouchUpInside) (NSInteger buttonAction, Search *search);

- (void)configurationData:(Search *)search cellType:(CellType)cellType;
- (void)setOnClickedTouchUpInside:(void (^ _Nonnull)(NSInteger buttonAction, Search * _Nonnull search))onClickedTouchUpInside;
@end

IB_DESIGNABLE
@protocol SearchHistoryViewControllerDelegate <NSObject>
- (void)searchHistoryViewControllerDidSearchKeyWord:(NSString *)keyword;
@end

@interface SearchHistoryViewController : UIViewController
@property (nonatomic, weak) id <SearchHistoryViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END

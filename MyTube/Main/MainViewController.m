//
//  MainViewController.m
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "MainViewController.h"
#import "VideoCell.h"
#import "RequestManager.h"
#import "HTextField.h"

#define HEIGHT_TOP 80

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, TabViewDelegate, TabViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet TabView *tabView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTitleView;
@property (nonatomic, assign) BOOL aniLock;
@property (nonatomic, strong) NSMutableArray *arrTab;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSerachClose;

@property (weak, nonatomic) IBOutlet HTextField *tfSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSearchView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrTab = [NSMutableArray array];
    [_arrTab addObject:@"노래"];
    [_arrTab addObject:@"영어학습"];
    [self.tabView reloadData];
    self.btnSerachClose.hidden = YES;
    
    
//    [[RequestManager instance] requestSerchList:@"노래" success:^(NSDictionary * _Nonnull data) {
//        int k = 0;
//    } failure:^(NSError * _Nonnull error) {
//        int k = 0;
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}
- (IBAction)onClickedButtonActions:(id)sender {
    if (sender == _btnSearch) {
        [_tfSearch becomeFirstResponder];
    }
    else if (sender == _btnSerachClose) {
        _tfSearch.text = @"";
        [self.view endEditing:YES];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil].firstObject;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark - TabViewDelegate TabViewDataSource
- (NSInteger)tabViewNumberOfCount {
    return _arrTab.count;
}
- (UIButton *)tabViewIndexOfButton:(NSInteger)index {
    TabButton *btn = [TabButton buttonWithType:UIButtonTypeCustom];
    btn.colorNormal = nil;
    btn.colorSelect = [UIColor redColor];
    btn.underLineWidth = 2.0;
    
    NSString *title = [_arrTab objectAtIndex:index];
    
    NSAttributedString *attrNor = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    NSAttributedString *attrSel = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor redColor]}];
    
    [btn setAttributedTitle:attrNor forState:UIControlStateNormal];
    [btn setAttributedTitle:attrSel forState:UIControlStateSelected];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    return btn;
}

- (void)tabViewDidClickedAtIndex:(NSInteger)index {
    NSLog(@"selIndex: %ld", index);
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat moveY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
//    CGFloat velocityY = [scrollView.panGestureRecognizer velocityInView:scrollView.superview].y;
    moveY = moveY/2.0;
    CGFloat minY = - HEIGHT_TOP;
    if (moveY < 0) { // up
        if (_aniLock == NO && _topTitleView.constant != minY) {
            _aniLock = YES;
            if (moveY < minY) {
                moveY = minY;
            }
            _topTitleView.constant = moveY;
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.topTitleView.constant = minY;
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.aniLock = NO;
                }];
            }];
        }
    }
    else if (moveY > 0) { //down
        if (_aniLock == NO && _topTitleView.constant < 0) {
            _aniLock = YES;
            moveY = _topTitleView.constant + moveY;
            if (moveY > 0) {
                moveY = 0;
            }
            _topTitleView.constant = moveY;
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.topTitleView.constant = 0;
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.aniLock = NO;
                }];
            }];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        
    }
    else {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - notificationHandler
- (void)notificationHandler:(NSNotification *)notification {
    CGFloat heightKeyboard = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        _btnSerachClose.hidden = NO;
        self.bottomSearchView.constant = heightKeyboard;
        [UIView animateWithDuration:duration animations:^{
             [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        self.bottomSearchView.constant = 0;
        self.btnSerachClose.hidden = YES;
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end

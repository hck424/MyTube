//
//  SearchHistoryViewController.m
//  MyTube
//
//  Created by 김학철 on 2020/05/28.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "RequestManager.h"
@interface SearchHistoryCell ()
@property (nonatomic, strong) Search *search;
@end
@implementation SearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configurationData:(Search *)search cellType:(CellType)cellType {
    self.search = search;
    _btnDelete.hidden = YES;
    _btnUp.hidden = YES;
    _lbTitle.text = search.keyword;
    if (cellType == CellTypeEdit) {
        _btnDelete.hidden = NO;
        _btnUp.hidden = NO;
    }
}

- (IBAction)onClickedDeleteAction:(UIButton *)sender {
    NSInteger btnAction = -1;
    if (sender == _btnUp) {
        btnAction = 0;
    }
    else if (sender == _btnDelete) {
        btnAction = 1;
    }
    if (btnAction >= 0 && self.onClickedTouchUpInside) {
        self.onClickedTouchUpInside(btnAction, _search);
    }
}

@end

@interface SearchHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HTextField *tfSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSearchView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSString *searchKeyword;

@end

@implementation SearchHistoryViewController
- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchHistoryViewController"];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrData = [NSMutableArray array];
    [_btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [_btnEdit setTitle:@"Done" forState:UIControlStateSelected];
    self.tblView.tableFooterView = [[UIView alloc] init];
    
    [self requestAllTag];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    [_tfSearch becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
}
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
}

- (IBAction)onClickedButtonActions:(UIButton *)sender {
    if (sender == _btnBack) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (sender == _btnEdit) {
        sender.selected = !sender.selected;
        [self.tblView reloadData];
    }
}

- (IBAction)textFieldEdtingChanged:(HTextField *)sender {
    if (sender.text.length > 0) {
        self.searchKeyword = sender.text;
    }
}

- (void)requestAllTag {
    [[RequestManager instance] fetchAllSearchList:^(NSArray * _Nonnull result) {
        if (result.count > 0) {
            [self.arrData setArray:result];
            [self.tblView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)insertSearchKeyWord:(NSString *)searchKeyword fixed:(BOOL)fixed {
    [[RequestManager instance] insertSearchKeyWord:searchKeyword fixed:fixed success:^{
        [self requestAllTag];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        NSString *searchKeyWord = textField.text;
        
        [[RequestManager instance] insertSearchKeyWord:searchKeyWord fixed:NO success:^{
            if ([self.delegate respondsToSelector:@selector(searchHistoryViewControllerDidSearchKeyWord:)]) {
                [self.delegate searchHistoryViewControllerDidSearchKeyWord:searchKeyWord];
            }
            [self.navigationController popViewControllerAnimated:NO];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
    else {
        [self.view endEditing:YES];
    }
    return YES;
}

//MARK:: //UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell"];
    if (cell == nil) {
        cell = (SearchHistoryCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchHistoryCell"];
    }
    Search *search = [_arrData objectAtIndex:indexPath.row];
    CellType type = CellTypeNorMal;
    
    if (_btnEdit.selected) {
        type = CellTypeEdit;
    }
    
    [cell configurationData:search cellType:type];
    [cell setOnClickedTouchUpInside:^(NSInteger buttonAction, Search * _Nonnull search) {
        if (buttonAction == 0) {
            
            [self.arrData removeObject:search];
            [self.arrData insertObject:search atIndex:0];
            
            [[RequestManager instance] insertSearchKeyWord:search.keyword fixed:search.fixed success:^{
                [self.tblView reloadData];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@", error.localizedDescription);
            }];
        }
        else if (buttonAction == 1) {
            [[RequestManager instance] deleteSearchHistory:search success:^{
                [self requestAllTag];
            } failure:^(NSError * _Nonnull error) {
                 NSLog(@"%@", error.localizedDescription);
            }];
        }
    }];
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        Search *delObj = [_arrData objectAtIndex:indexPath.row];
//        [[RequestManager instance] deleteSearchHistory:delObj success:^{
//            NSLog(@"success");
//        } failure:^(NSError * _Nonnull error) {
//            NSLog(@"error: %@", error.localizedDescription);
//        }];
//        [_arrData removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//    }
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    Search *movedObj = [_arrData objectAtIndex:sourceIndexPath.row];
//    [_arrData removeObjectAtIndex:sourceIndexPath.row];
//    [_arrData insertObject:movedObj atIndex:destinationIndexPath.row];
//
//    [[RequestManager instance] insertSearchKeyWord:movedObj.keyword fixed:movedObj.fixed success:nil failure:nil];
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - notificationHandler
- (void)notificationHandler:(NSNotification *)notification {
    CGFloat heightKeyboard = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        self.bottomSearchView.constant = heightKeyboard;
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        self.bottomSearchView.constant = 0;
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}
@end

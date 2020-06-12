//
//  RootViewController.m
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "RootViewController.h"
#import "VideoCell.h"
#import "RequestManager.h"
#import "HTextField.h"
#import "Search+CoreDataProperties.h"
#import "XCDYouTubeClient.h"
#import "UIView+Toast.h"
#import "PlayerManager.h"
#import "AppDelegate.h"
#import "UIViewController+Utility.h"
#import "SearchHistoryViewController.h"

#define HEIGHT_TOP 80
@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, TabViewDelegate, TabViewDataSource, UITextFieldDelegate, SearchHistoryViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLogo;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet TabView *tabView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTitleView;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;


@property (nonatomic, assign) BOOL aniLock;
@property (nonatomic, strong) NSArray *arrTab;
@property (nonatomic, strong) NSString *searchKeyWord;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSDictionary *selDic;
@property (nonatomic, assign) NSInteger tapIndex;
@property (nonatomic, strong) NSDictionary *selCategory;
@property (nonatomic, assign) BOOL didEndBackground;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrData = [NSMutableArray array];
    
//    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kUSER_APP_FIRST_LAUNCHE];
//    if (isFirstLaunch == NO) {
//        NSString *keyword = NSLocalizedString(@"tag_song", nil);
//        [self insertSearchKeyWord:keyword fixed:YES];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUSER_APP_FIRST_LAUNCHE];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    _tblView.estimatedRowHeight = 250;
    _tblView.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:NotificationNameChangePlayItem object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestAllTag];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}

- (void)requestAllTag {
    [[RequestManager instance] requestAllCategory:^(NSArray * _Nonnull result) {
        if (result.count > 0) {
            self.tblView.hidden = NO;
            self.arrTab = result;
            self.tabView.activateIndex = 0;
            [self.tabView reloadData];
        }
        else {
            self.tblView.hidden = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)requestCategoryList {
    if (_selCategory == nil) {
        return;
    }
    NSString *category = [_selCategory objectForKey:@"category"];
    [[RequestManager instance] requestCategoryList:category  success:^(NSArray * _Nonnull result) {
        if (result.count > 0) {
            [self.arrData setArray:result];
            [self.tblView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

//- (void)parserYTVideoUrl:(NSArray *)arr {
//    __block NSInteger count = 0;
//    for (NSDictionary *itemDic in arr) {
//
//        __block NSString *videoId = [[itemDic objectForKey:@"id"] objectForKey:@"videoId"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[AppDelegate instace] startIndicator];
//        });
//
//        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoId completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
//
//            if (error == nil && video.streamURL != nil) {
//                NSURL *url = video.streamURL;
//                NSLog(@"%@", url);
//                NSNumber *length = [NSNumber numberWithDouble:video.duration];
//                for (NSInteger i = 0; i < self.arrData.count; i++) {
//                    NSMutableDictionary *dic = [[self.arrData objectAtIndex:i] mutableCopy];
//                    NSString *findVideoId = [[dic objectForKey:@"id"] objectForKey:@"videoId"];
//                    if ([findVideoId isEqualToString:videoId]) {
//                        [dic setObject:url forKey:@"video_url"];
//                        [dic setObject:length forKey:@"video_length"];
//
//                        [self.arrData replaceObjectAtIndex:i withObject:dic];
//                        count++;
//                        break;
//                    }
//                }
//                [[PlayerManager instance] addPlayItem:url];
//
//                if (count == arr.count) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"paser end");
//                        [self.tblView reloadData];
////                        [[AppDelegate instace] stopIndicator];
//                    });
//                }
//            }
//            else {
//                NSLog(@"youtube url parsing error: %@", videoId);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[AppDelegate instace] stopIndicator];
//                });
//            }
//        }];
//    }
//}

- (IBAction)onClickedButtonActions:(id)sender {
    if (sender == _btnSearch) {
        [self requestAllTag];
        return;
    }
    else if (_btnLogo == sender) {
        MainViewController *mainVc = (MainViewController *)self.sideMenuController;
        [mainVc showLeftViewAnimated:YES completionHandler:nil];
        
        if ([mainVc.leftViewController respondsToSelector:@selector(reloadData)]) {
            [mainVc.leftViewController performSelector:@selector(reloadData)];
        }
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil].firstObject;
    }
    NSDictionary *itemDic = [_arrData objectAtIndex:indexPath.row];
    [cell configurationData:itemDic];
    [cell setOnClickedTouchUpInside:^(NSDictionary * _Nonnull itemDic, NSInteger buttonAction) {
        if (buttonAction == 1) {
            [self.tblView reloadData];
        }
    }];
    
    if (self.didEndBackground) {
        [cell.avPlayerView destroyLayer];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *itemDic = [_arrData objectAtIndex:indexPath.row];
    
    int k = 0;
    
}

#pragma mark - TabViewDelegate TabViewDataSource
- (void)tabViewDidClickedAtIndex:(NSInteger)index {
    NSLog(@"selIndex: %ld", index);
    [self.view endEditing:YES];
    if (index != _tapIndex) {
        self.tapIndex = index;
        [_arrData removeAllObjects];
        
        [[PlayerManager instance].playQueue removeAllObjects];
        if ([PlayerManager instance].isPlaying) {
            [[PlayerManager instance] cleanPlayer];
        }
    }
    
    self.selCategory = [_arrTab objectAtIndex:_tapIndex];
    [self requestCategoryList];
}

- (NSInteger)tabViewNumberOfCount {
    return _arrTab.count;
}

- (UIButton *)tabViewIndexOfButton:(NSInteger)index {
    TabButton *btn = [TabButton buttonWithType:UIButtonTypeCustom];
    btn.colorNormal = nil;
    btn.colorSelect = [UIColor redColor];
    btn.underLineWidth = 2.0;
    
    NSDictionary *category = [_arrTab objectAtIndex:index];
    NSDictionary *titleDic = [category objectForKey:@"title"];
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    NSString *title = @"";
    if ([language isEqualToString:@"ko"]) {
        title = [titleDic objectForKey:@"ko"];
    }
    else {
        title = [titleDic objectForKey:@"en"];
    }
    
    NSAttributedString *attrNor = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    NSAttributedString *attrSel = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor redColor]}];
    
    [btn setAttributedTitle:attrNor forState:UIControlStateNormal];
    [btn setAttributedTitle:attrSel forState:UIControlStateSelected];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    return btn;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat moveY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
    CGFloat velocityY = [scrollView.panGestureRecognizer velocityInView:scrollView.superview].y;
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
    
    if (velocityY > 0) {
        NSLog(@"%@", @"UP");
    }
    else if (velocityY < 0) {
        NSLog(@"%@", @"Down");
    }
}

#pragma mark - notificationHandler
- (void)notificationHandler:(NSNotification *)notification {
   if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        NSLog(@"didendbackground");
        self.didEndBackground = YES;
        [self.tblView reloadData];
    }
    else if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        NSLog(@"willforground");
        self.didEndBackground = NO;
        [self.tblView reloadData];
    }
    else if ([notification.name isEqualToString:NotificationNameChangePlayItem]) {
        NSLog(@"changePlayItem MP");
        self.didEndBackground = YES;
        [self.tblView reloadData];
    }
}

@end

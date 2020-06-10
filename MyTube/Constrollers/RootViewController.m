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

@property (nonatomic, strong) Search *selTag;
@property (nonatomic, assign) BOOL aniLock;
@property (nonatomic, strong) NSArray *arrTab;
@property (nonatomic, strong) NSString *searchKeyWord;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSString *nextPageToken;
@property (nonatomic, strong) NSDictionary *selDic;
@property (nonatomic, assign) NSInteger tapIndex;

@property (nonatomic, assign) BOOL didEndBackground;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrData = [NSMutableArray array];
    
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kUSER_APP_FIRST_LAUNCHE];
    if (isFirstLaunch == NO) {
        NSString *keyword = NSLocalizedString(@"tag_song", nil);
        [self insertSearchKeyWord:keyword fixed:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUSER_APP_FIRST_LAUNCHE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
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
    [[RequestManager instance] fetchAllSearchList:^(NSArray * _Nonnull result) {
        if (result.count > 0) {
            self.tabView.hidden = NO;
            self.arrTab = result;
            
            self.tapIndex = 0;
            for (NSInteger i = 0; i < self.arrTab.count; i++) {
                Search *search = [self.arrTab objectAtIndex:i];
                if ([search.keyword isEqualToString:self.searchKeyWord]) {
                    self.tapIndex = i;
                    break;
                }
            }
            self.tabView.activateIndex = self.tapIndex;
            [self.tabView reloadData];
        }
        else {
            self.tabView.hidden = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}
- (void)addYoutubeSearch {
    [self requestYoutubeSearchList];
}
- (void)requestYoutubeSearchList {
    if (_selTag == nil) {
        return;
    }
    
    [[RequestManager instance] requestYoutubeSearchList:_selTag.keyword
                                             maxResults:5
                                                pageKey:_nextPageToken
                                                success:^(NSDictionary * _Nonnull result)
     {
        NSArray *arr = [result objectForKey:@"items"];
        if (arr.count > 0) {
            if (self.nextPageToken.length > 0) {
                [self.arrData setArray:arr];
            }
            else {
                [self.arrData addObjectsFromArray:arr];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self parserYTVideoUrl:arr];
            });
            
            self.nextPageToken = [result objectForKey:@"nextPageToken"];
            [self.tblView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)parserYTVideoUrl:(NSArray *)arr {
    __block NSInteger count = 0;
    for (NSDictionary *itemDic in arr) {
        
        __block NSString *videoId = [[itemDic objectForKey:@"id"] objectForKey:@"videoId"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[AppDelegate instace] startIndicator];
//        });
        
        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoId completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
            
            if (error == nil && video.streamURL != nil) {
                NSURL *url = video.streamURL;
                NSLog(@"%@", url);
                NSNumber *length = [NSNumber numberWithDouble:video.duration];
                for (NSInteger i = 0; i < self.arrData.count; i++) {
                    NSMutableDictionary *dic = [[self.arrData objectAtIndex:i] mutableCopy];
                    NSString *findVideoId = [[dic objectForKey:@"id"] objectForKey:@"videoId"];
                    if ([findVideoId isEqualToString:videoId]) {
                        [dic setObject:url forKey:@"video_url"];
                        [dic setObject:length forKey:@"video_length"];
                        
                        [self.arrData replaceObjectAtIndex:i withObject:dic];
                        count++;
                        break;
                    }
                }
                [[PlayerManager instance] addPlayItem:url];
                
                if (count == arr.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"paser end");
                        [self.tblView reloadData];
//                        [[AppDelegate instace] stopIndicator];
                    });
                }
            }
            else {
                NSLog(@"youtube url parsing error: %@", videoId);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[AppDelegate instace] stopIndicator];
//                });
            }
        }];
    }
}

- (IBAction)onClickedButtonActions:(id)sender {
    if (sender == _btnSearch) {
        SearchHistoryViewController *vc = [[SearchHistoryViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if (_btnLogo == sender) {
        
//        NSURL *url = [NSURL URLWithString:@"hanpassapp://"];
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//        }
//        else {
//            int k = 0;
//        }
//        return;
        
        MainViewController *mainVc = (MainViewController *)self.sideMenuController;
        [mainVc showLeftViewAnimated:YES completionHandler:nil];
        
        if ([mainVc.leftViewController respondsToSelector:@selector(reloadData)]) {
            [mainVc.leftViewController performSelector:@selector(reloadData)];
        }
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_arrData.count > 0
        && indexPath.row == _arrData.count -1) {
        [self addYoutubeSearch];
    }
}
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
        self.nextPageToken = nil;
        [[PlayerManager instance].playQueue removeAllObjects];
        if ([PlayerManager instance].isPlaying) {
            [[PlayerManager instance] cleanPlayer];
        }
    }
    
    self.selTag = [_arrTab objectAtIndex:index];
    [self requestYoutubeSearchList];
}

- (NSInteger)tabViewNumberOfCount {
    return _arrTab.count;
}
- (UIButton *)tabViewIndexOfButton:(NSInteger)index {
    TabButton *btn = [TabButton buttonWithType:UIButtonTypeCustom];
    btn.colorNormal = nil;
    btn.colorSelect = [UIColor redColor];
    btn.underLineWidth = 2.0;
    
    Search *search = [_arrTab objectAtIndex:index];
    NSString *title = search.keyword;
    
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

- (void)insertSearchKeyWord:(NSString *)searchKeyword fixed:(BOOL)fixed {
    [[RequestManager instance] insertSearchKeyWord:searchKeyword fixed:fixed success:^{
        [self requestAllTag];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
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

#pragma mark - SearchHistoryViewControllerDelegate
- (void)searchHistoryViewControllerDidSearchKeyWord:(NSString *)keyword {
    self.searchKeyWord = keyword;
}

@end

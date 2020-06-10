//
//  LeftTableViewController.m
//  MyTube
//
//  Created by 김학철 on 2020/05/27.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "LeftTableViewController.h"

@interface LeftTableViewController ()
@property (nonatomic, strong) NSMutableArray *arrData;
@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeTableData];
}

- (void)makeTableData {
    if (_arrData == nil) {
        self.arrData = [NSMutableArray array];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cell_id_tag", @"cell_id",
                    NSLocalizedString(@"edit_tags", nil), @"title", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cell_id_time", @"cell_id",
                    NSLocalizedString(@"time_setting", nil), @"title", nil]];
    [_arrData addObject:arr];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[_arrData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSDictionary *item = [[_arrData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *title = [item objectForKey:@"title"];
    cell.textLabel.text = title;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"setting", nil);
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end

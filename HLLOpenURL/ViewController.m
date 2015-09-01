//
//  ViewController.m
//  HLLOpenURL
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import "ViewController.h"
#import "SDWebImageManager.h"
#import "HLLOpenClass.h"
#import "HLLTableViewCell.h"
#import "HLLDataSource.h"

@interface ViewController ()<UITableViewDelegate>

@property (nonatomic ,strong) HLLDataSource * dataSource;
@end

static NSString * cellIdentifier = @"openURLCellIdentifier";

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self _addData];
    [self _configureNavigatioinBar];
    [self _addSubView];
}

#pragma mark - Data
- (void) _addData{

    TableViewCellConfigureBlock configureBlock = ^(HLLTableViewCell * cell ,HLLOpenClass * openClass){
        [cell configureCellWithOpenClass:openClass];
    };
    _dataSource = [[HLLDataSource alloc] initWithCellIdentifier:cellIdentifier
                                             configureCellBlock:configureBlock];

}
#pragma mark - UI
- (void) _configureNavigatioinBar{

    UILabel * headlinelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    headlinelabel.font = [UIFont fontWithName:@"Courier New" size:28];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor = [UIColor whiteColor];
    
    self.title = @"Quick Launch";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor orangeColor]
                             range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Gill Sans" size:28]
                             range:NSMakeRange(6, 6)];
    headlinelabel.attributedText = attributedString;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:92/255.0 green:114/255.0 blue:179/255.0 alpha:1];
    [self.navigationItem setTitleView:headlinelabel];
}
- (void) _addSubView{

    CGFloat addressTabelViewX = 0;
    CGFloat addressTabelViewY = 0;
    CGFloat addressTabelViewW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat addressTabelViewH = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGRect addressTabelViewFrame = CGRectMake(addressTabelViewX, addressTabelViewY, addressTabelViewW, addressTabelViewH);
    UITableView * _tableView = [[UITableView alloc] initWithFrame:addressTabelViewFrame style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor colorWithRed:92/255.0 green:114/255.0 blue:179/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self.dataSource;
    _tableView.tableHeaderView = [self tableViewHeaderView];
    _tableView.tableFooterView = [self tableViewFooterView];
    _tableView.separatorColor = [UIColor clearColor];
    [_tableView registerNib:[HLLTableViewCell nib] forCellReuseIdentifier:cellIdentifier];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview: _tableView];
}

- (UIView *) tableViewHeaderView{
    
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0.1);
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UIView *) tableViewFooterView{
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0.1);
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
#pragma mark - delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 16;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(headerView.bounds) - 40, CGRectGetHeight(headerView.bounds))];
    label.text = [self.dataSource dataSource_titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HLLOpenClass * openClass = (HLLOpenClass *)[self.dataSource itemWithIndexPath:indexPath];
    
    [self openUrlWithOpenClass:openClass];
#if 0

    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
#endif
}

#pragma mark - openUrl

- (void) openUrlWithOpenClass:(HLLOpenClass *)openClass{
    
    NSArray * schemes = openClass.schemes;
    [schemes enumerateObjectsUsingBlock:^(NSString * item, NSUInteger idx, BOOL *stop) {
        
        NSString * schem;
        if (![item hasSuffix:@"://"]) {
            schem = [NSString stringWithFormat:@"%@://",item];
        }else{
            schem = item;
        }
        NSURL * url = [NSURL URLWithString:schem];
        BOOL openWeibo = [[UIApplication sharedApplication] openURL:url];
        *stop = openWeibo;
    }];
}

@end

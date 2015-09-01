//
//  HLLDataSource.h
//  HLLOpenURL
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface HLLDataSource : NSObject<UITableViewDataSource>


- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
          configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id) itemWithIndexPath:(NSIndexPath *)indexPath;

- (NSArray  *) dataSource_sectionsWithSortAllKeysForOpenDictionary;
- (NSArray  *) dataSource_rowsAtOneSection:(NSInteger)section;
- (NSString *) dataSource_titleForHeaderInSection:(NSInteger)section;
@end

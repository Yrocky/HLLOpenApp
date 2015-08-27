//
//  HLLTableViewCell.h
//  HLLOpenURL
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLLOpenClass;
@interface HLLTableViewCell : UITableViewCell

+ (UINib *) nib;
- (void) configureCellWithOpenClass:(HLLOpenClass *)openClass;
@end

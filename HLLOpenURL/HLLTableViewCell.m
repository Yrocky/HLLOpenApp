//
//  HLLTableViewCell.m
//  HLLOpenURL
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import "HLLTableViewCell.h"
#import "HLLOpenClass.h"
#import "SDWebImageManager.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface HLLTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageVIew;

@end
@implementation HLLTableViewCell

+ (UINib *) nib{

    return [UINib nibWithNibName:@"HLLTableViewCell" bundle:nil];
}
- (void)awakeFromNib {
    
}

- (void)configureCellWithOpenClass:(HLLOpenClass *)openClass{

    self.nameLabel.text = openClass.name;
    
    NSURL * imageURL = [NSURL URLWithString:openClass.icon];
    
    [self.iconImageVIew sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon"]];
    
//    [manager cachedImageExistsForURL:imageURL completion:^(BOOL isInCache) {
//       
//        if (isInCache) {
//            self.iconImageVIew.image = [UIImage alloc] ini
//        }else{
//            [manager downloadImageWithURL:imageURL
//                                  options:0
//                                 progress:nil
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                    if (image) {
//                                        self.iconImageVIew.image = image;
//                                    }
//                                    [manager saveImageToCache:image forURL:imageURL];
//                                }];
//        }
//    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

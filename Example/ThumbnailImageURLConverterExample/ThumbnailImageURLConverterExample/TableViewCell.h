//
//  TableViewCell.h
//  ThumbnailImageURLConverterExample
//
//  Created by Yu Sugawara on 2016/03/07.
//  Copyright © 2016年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *URLLabel;

@end

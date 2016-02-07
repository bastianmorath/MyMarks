//
//  MMSubtitleCellTableViewCell.h
//  MyMarks
//
//  Created by Bastian Morath on 2/7/16.
//  Copyright © 2016 Bastian Morath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSubtitleCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

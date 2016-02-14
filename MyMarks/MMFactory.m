//
//  MMFactory.m
//  Notenapplikation
//
//  Created by Bastian Morath on 29/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMFactory.h"

@implementation MMFactory

const int NumberOfRowsForIPhone4 = 8;
const int NumberOfRowsForIPhone5 = 9;
const int NumberOfRowsForIPhone6 = 9;
const int NumberOfRowsForIPhone6P = 9;
const int NumberOfRowsForIPad = 11;




+(UIBarButtonItem *)appIconItem{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage* appImage = [UIImage imageNamed:@"App Icon.png"];
    [imageView setImage:appImage];
    
    UIBarButtonItem *showIcon =[[UIBarButtonItem alloc] initWithCustomView:imageView];
    return showIcon;
}

+(UIBarButtonItem *)editIconItemForClass:(id)class{
    UIImage* image = [UIImage imageNamed:@"EditIcon.png"];
    CGRect frameimg = CGRectMake(0, 0, 30, 30);
    UIButton *addButton = [[UIButton alloc] initWithFrame:frameimg];
    [addButton setBackgroundImage:image forState:UIControlStateNormal];
    [addButton addTarget:class action:@selector(editPressed:)
        forControlEvents:UIControlEventTouchUpInside];
    [addButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *editBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    return editBarButtonItem;
}

+(NSString *)NSStringFromDate:(NSDate*)date{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CH"];
    NSString *dateString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:usLocale];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = dateString;
    
    
    
    return [NSString stringWithFormat: @"%@", [df stringFromDate:date]] ;
}

+(NSDate *)NSDateFromString:(NSString*)string{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CH"];
    NSString *dateString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:usLocale];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = dateString;
    
    
    
    return [df dateFromString:string];
}
+(UIView*)navigationViewForString:(NSString *)string{
    UIView *customTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    customTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label= [[UILabel alloc]init];
    label.text=string;
    label.font=    [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    label.textColor=[UIColor whiteColor];
    [label setNumberOfLines:1];
    CGSize maximumLabelSize = CGSizeMake(9999,label.frame.size.height);
    CGRect textRect = [label.text boundingRectWithSize:maximumLabelSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[label font]}
                                         context:nil];
    CGSize labelSize = textRect.size;
    [customTitleView setFrame:CGRectMake(-(labelSize.width/2), 0, labelSize.width, labelSize.height)];
    [label setFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    [customTitleView addSubview:label];
    return customTitleView;
}

+(UIBarButtonItem *)backBarButtonItemForClass:(id)class{
    UIButton *arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, 0, 40, 40)];
    [arrowButton addTarget:class action:@selector(backPressed)
          forControlEvents:UIControlEventTouchUpInside];
    [arrowButton setShowsTouchWhenHighlighted:YES];
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(-7, 3, 30, 30)];
    [view setImage:[UIImage imageNamed:@"backArrow.png"]];
    [arrowButton addSubview:view];
    
    UIBarButtonItem *backBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:arrowButton];
    return backBarButtonItem;
}

+(float)heightForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==3)
    {
        return 2 * [self heightOfRow];
    }
    return [self heightOfRow];
}

+(float)heightOfRow{
    if IS_IPHONE_4_OR_LESS{
        return [self viewHeight]/NumberOfRowsForIPhone4;
    }
    
    if IS_IPHONE_5{
        return [self viewHeight]/NumberOfRowsForIPhone5;
    }
    
    if IS_IPHONE_6{
        return [self viewHeight]/NumberOfRowsForIPhone6;
    }
    if IS_IPHONE_6P{
        return [self viewHeight]/NumberOfRowsForIPhone6P;
    }
    if IS_IPAD{
        return [self viewHeight]/NumberOfRowsForIPad;
    } else { // Default value
        return [self viewHeight]/NumberOfRowsForIPhone5;
    }
}

+(int)numberOfRows{
    if IS_IPHONE_4_OR_LESS{
        return NumberOfRowsForIPhone4;
    }else if IS_IPHONE_5{
        return NumberOfRowsForIPhone5;
    }else  if IS_IPHONE_6{
        return NumberOfRowsForIPhone6;
    }else if IS_IPHONE_6P{
        return NumberOfRowsForIPhone6P;
    }else if IS_IPAD{
        return NumberOfRowsForIPad;
    }else { // Default value
        return 10;
    }
}

+(float)viewHeight{
    return [[UIApplication sharedApplication] keyWindow].frame.size.height - 64;
}

+(UIColor *)greenColor{
    return [UIColor colorWithRed:157/255.0f green:229/255.0f blue:131/255.0f alpha:1];
}

+(UIColor *)blueColor{
    return [UIColor colorWithRed:28/255.0f green:125/255.0f blue:253/255.0f alpha:1];
}
+(UIColor *)placeholderBlueColor{
    return [UIColor lightGrayColor];
}

+(UIColor *)darkGreenColor{
    return [UIColor colorWithRed:128/255.0f green:205/255.0f blue:159/255.0f alpha:1];
}

+(NSString*)formatTypeToString:(int)formatType {
    NSString *result = nil;
    // FIXME: Localize strings
    switch(formatType) {
        case kAverage:
            result = NSLocalizedString(@"Average (Default)", nil);
            break;
        case kAverageAndPluspoints:
            result = NSLocalizedString(@"Average and Pluspoints (Swiss)", nil);
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}


@end

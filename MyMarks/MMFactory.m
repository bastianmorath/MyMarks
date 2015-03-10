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
    CGSize labelSize = [label.text sizeWithFont:[label font]
                              constrainedToSize:maximumLabelSize
                                  lineBreakMode:[label lineBreakMode]];
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

+(void)initGoogleAnalyticsForClass:(id)class{
    //**Google Analytics**//
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:NSStringFromClass([class class])];
    
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

+(UIColor *)blueColor{
    return [UIColor colorWithRed:29/255.0f green:125/255.0f blue:253/255.0f alpha:1];
}

//+(float)heightForIndexPath:(NSIndexPath *)indexPath AndViewHeight:(float)height{
//    float tableViewHeight = height;
//    
//    if IS_IPHONE_4_OR_LESS{
//        if (indexPath.row ==3)
//        {
//            return 2*tableViewHeight/(NumberOfRowsForIPhone4+1);
//        }
//        NSLog(@"%f", tableViewHeight/(NumberOfRowsForIPhone4+1));
//        return tableViewHeight/(NumberOfRowsForIPhone4+1);
//    }
//    
//    if IS_IPHONE_5{
//        if (indexPath.row ==3)
//        {
//            return 2*tableViewHeight/(NumberOfRowsForIPhone5+1);
//        }
//        NSLog(@"%f", tableViewHeight/(NumberOfRowsForIPhone5+1));
//
//        return tableViewHeight/(NumberOfRowsForIPhone5+1);
//    }
//    
//    if IS_IPHONE_6{
//        if (indexPath.row ==3)
//        {
//            return 2*tableViewHeight/(NumberOfRowsForIPhone6+1);
//        }
//        NSLog(@"%f", tableViewHeight/(NumberOfRowsForIPhone6+1));
//
//        return tableViewHeight/(NumberOfRowsForIPhone6+1);    }
//    
//    if IS_IPHONE_6P{
//        if (indexPath.row ==3)
//        {
//            return 2*tableViewHeight/(NumberOfRowsForIPhone6P+1);
//        }
//        NSLog(@"%f", tableViewHeight/(NumberOfRowsForIPhone6P+1));
//
//        return tableViewHeight/(NumberOfRowsForIPhone6P+1);
//    }
//    if IS_IPAD{
//        if (indexPath.row ==3)
//        {
//            return 2*tableViewHeight/(NumberOfRowsForIPad+1);
//        }
//        NSLog(@"%f", tableViewHeight/(NumberOfRowsForIPad+1));
//
//        return tableViewHeight/(NumberOfRowsForIPad+1);
//    } else { // Default value
//        if (indexPath.row ==3)
//        {
//            return 2*tableViewHeight/(NumberOfRowsForIPhone5+1);
//        }
//        return tableViewHeight/(NumberOfRowsForIPhone5+1);
//    }
//
//}

+(float)heightForIndexPath:(NSIndexPath *)indexPath{
    
    if IS_IPHONE_4_OR_LESS{
        if (indexPath.row ==3)
        {
            return 2 * HeightOfRowForIPhone4;
        }
        return HeightOfRowForIPhone4;
    }
    
    if IS_IPHONE_5{
        if (indexPath.row ==3)
        {
            return 2 * HeightOfRowForIPhone5;
        }
        return HeightOfRowForIPhone5;
    }
    
    if IS_IPHONE_6{
        if (indexPath.row ==3)
        {
            return 2 * HeightOfRowForIPhone6;
        }
        return HeightOfRowForIPhone6;
    }
    if IS_IPHONE_6P{
        if (indexPath.row ==3)
        {
            return 2 * HeightOfRowForIPhone6P;
        }
        return HeightOfRowForIPhone6P;
    }
    if IS_IPAD{
        if (indexPath.row ==3)
        {
            return 2 * HeightOfRowForIPad;
        }
        return HeightOfRowForIPad;
    } else { // Default value
        if (indexPath.row ==3)
        {
            return 2 * HeightOfRowForIPhone4;
        }
        return HeightOfRowForIPhone4;
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


@end

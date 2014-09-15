//
//  MMFactory.m
//  Notenapplikation
//
//  Created by Bastian Morath on 29/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMFactory.h"

@implementation MMFactory


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
    label.font=    [UIFont fontWithName:@"Helvetica Neue Light" size:17];
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
@end

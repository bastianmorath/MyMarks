//
//  MMFactory.m
//  Notenapplikation
//
//  Created by Bastian Morath on 29/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMFactory.h"

@implementation MMFactory

+(float)plusPoints{
    float plusPoints =0;
    for (Subject *eachSubject in [[DataStore defaultStore]getSubjects])
    {
        
        if ([eachSubject.weighting intValue] == 1)
        {
            if(eachSubject.average !=0)
            {
                if (round(eachSubject.average * 2) / 2<4) //Wenn der gerundete Durchscnitt kleiner als 4 ist, wird die if-Schlaufe durchlaufen
                {
                    plusPoints -=  2* (4-round(eachSubject.average * 2) / 2);// Subtrahiert zweimal den Wert unter 4
                } else
                {
                    plusPoints +=  (round(eachSubject.average * 2) / 2)-4;   // Addiert einmal den Wert über 4
                }
            }
        }
    }
    
    return plusPoints;
}

+(float)average{
    if ([[[DataStore defaultStore]getSubjects]count]!=0) {
        float numberOfSubjects =0;
        float tempCount = 0;
        for (Subject *eachSubject in [[DataStore defaultStore]getSubjects]){
            if (eachSubject.average!=0) {
                numberOfSubjects++;
                tempCount += eachSubject.average;
            }
        }
        return tempCount / numberOfSubjects;
    } else {
        return 0.0;
    }
}

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
+(UIView*)getNavigationViewForString:(NSString *)string{
    UIView *customTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    customTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label= [[UILabel alloc]init];
    label.text=string;
    label.font=    [UIFont fontWithName:@"Helvetica Light" size:17];
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
    UIImage* image = [UIImage imageNamed:@"backArrow.png"];
    CGRect frameimg = CGRectMake(-3, 9, 18, 18);
    UIButton *arrowButton = [[UIButton alloc] initWithFrame:frameimg];
    [arrowButton setBackgroundImage:image forState:UIControlStateNormal];
    [arrowButton addTarget:class action:@selector(backPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [arrowButton setShowsTouchWhenHighlighted:YES];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [view addSubview:arrowButton];
    UIBarButtonItem *backBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:view];
    return backBarButtonItem;
}
@end

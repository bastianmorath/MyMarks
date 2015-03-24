//
//  MMFactory.h
//  Notenapplikation
//
//  Created by Bastian Morath on 29/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMFactory : NSObject

+(UIBarButtonItem *)appIconItem;
+(UIBarButtonItem *)editIconItemForClass:(id)class;
+(NSString *)NSStringFromDate:(NSDate*)date;
+(NSDate *)NSDateFromString:(NSString*)string;
+(UIView *)navigationViewForString:(NSString *)string;
+(UIBarButtonItem *)backBarButtonItemForClass:(id)class;
+(void)initGoogleAnalyticsForClass:(id)class;
+(float)heightForIndexPath:(NSIndexPath *)indexPath;
+(float)heightOfRow;
+(int)numberOfRows;
/// Height of View without status- + navigationbar
+(float)viewHeight;
+(UIColor *)greenColor;
+(UIColor *)blueColor;
+(UIColor *)placeholderBlueColor;
+(UIColor *)darkGreenColor;


typedef enum GradingType : NSUInteger {
    k1to6,
    k6to1,
    kUSA,
    k1to5,
    k1to20,
    kNumberOfObjects
} GradingType;

+(NSString*)formatTypeToString:(GradingType)formatType;


@end

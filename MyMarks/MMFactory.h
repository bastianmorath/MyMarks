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
+(UIColor *)blueColor;
+(float)heightForIndexPath:(NSIndexPath *)indexPath;
+(int)numberOfRows;
@end

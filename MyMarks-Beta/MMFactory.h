//
//  MMFactory.h
//  Notenapplikation
//
//  Created by Bastian Morath on 29/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMFactory : NSObject

+(float)plusPoints;
+(UIBarButtonItem *)appIconItem;
+(UIBarButtonItem *)editIconItemForClass:(id)class;

@end

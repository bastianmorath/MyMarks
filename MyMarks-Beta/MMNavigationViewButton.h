//
//  MMNavigationViewButton.h
//  Notenapplikation
//
//  Created by Bastian Morath on 06/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMNavigationViewButton : UIButton
{
    UILabel *label;
}
@property (nonatomic) enum buttonType type;

-(void)updateText;
-(instancetype)initWithType:(enum buttonType)type AndTarget:(id)class;

@end

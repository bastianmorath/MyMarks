//
//  ATBarButtonItem.h
//  AntumTrainer
//
//  Created by Bastian Morath on 12/07/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//
//Diese Klasse ist eine Subclass von UIBarButtonItem.
//Initialisiert wird sie mit der Position (PTLeft or PTRight) und dem IconType
// Die Actions sind: leftBarButtonItemPressed  und rightBarButtonPressed , diese müssen in den Controller vorhanden sein
#import <UIKit/UIKit.h>

@interface MMBarButtonItem : UIBarButtonItem{
    UIImageView *imageView;
    UILabel *textLabel;
    id target;
    UIButton *button;
}

@property (nonatomic) enum ATPosition position;

-(instancetype)initWithText:(NSString*)text target:(id)class Position:(enum ATPosition)position;
@end

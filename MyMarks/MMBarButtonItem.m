//
//  ATBarButtonItem.m
//  AntumTrainer
//
//  Created by Bastian Morath on 12/07/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMBarButtonItem.h"

@implementation MMBarButtonItem

@synthesize textLabel;

-(instancetype)initWithText:(NSString*)text target:(id)class Position:(enum ATPosition)position
{

    if (self)
    {

        button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        target=class;

        self.position=position;

        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 13, 80, 15)];
        textLabel.text = text;
        [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        textLabel.textColor= [UIColor whiteColor];
        [button addSubview:textLabel];
 
        self = [super initWithCustomView:button];

    }
        return self;
}





-(void)setPosition:(enum ATPosition)position
{
    button = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 40, 40)];
    [button setBackgroundColor:[UIColor clearColor]];

    //Position: Left
    if (position==0)
    {
        [button addTarget:target action:@selector(leftBarButtonItemPressed) forControlEvents:UIControlEventTouchUpInside];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-5, 0, 30, 30)];
    } else
        //Poition: Right
    {
        [button addTarget:target action:@selector(rightBarButtonItemPressed) forControlEvents:UIControlEventTouchUpInside];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    }
}

    
    


@end
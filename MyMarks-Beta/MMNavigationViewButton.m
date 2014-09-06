//
//  MMNavigationViewButton.m
//  Notenapplikation
//
//  Created by Bastian Morath on 06/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMNavigationViewButton.h"

@implementation MMNavigationViewButton



-(instancetype)initWithType:(enum buttonType)type AndTarget:(id)class{
    self = [super initWithFrame:CGRectMake(-50, 0, 100, 50)];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(-55, 0, 200, 50)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"Helvetica Light" size:16]];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];

        self.type = type;
        [self addTarget:class action:@selector(navigationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}


-(void)updateText{
    self.type = self.type == 0 ? 1 :0;

    [[NSUserDefaults standardUserDefaults] setObject:@(self.type)  forKey:@"calcType"];

    switch (self.type) {
        case 0:
        {
            label.text = [NSString stringWithFormat:@"Average: %0.1f", [MMFactory average]];
            
        }
            break;
            
        case 1:
        {
            //Plus-/Minuspunkte anzeigen
            if ([MMFactory plusPoints]>=0) {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"Pluspoints: %0.1f", nil), [MMFactory plusPoints]];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"Minuspoints: %0.1f", nil), -[MMFactory plusPoints]];
            }
        }
            break;
        default:
            break;
    }

}
@end

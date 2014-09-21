//
//  MMNavigationViewButton.m
//  Notenapplikation
//
//  Created by Bastian Morath on 06/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMNavigationViewButton.h"

@implementation MMNavigationViewButton



-(instancetype)initWithTarget:(id)class
{
    self = [super initWithFrame:CGRectMake(-50, 0, 100, 50)];
    if (self)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(-50, -4, 200, 50)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
        NSNumber *counter = ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"tapCounter"]);

        if (counter)
        {
            tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, 12, 200, 50)];
            [tapLabel setTextAlignment:NSTextAlignmentCenter];
            [tapLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
            [tapLabel setText:@"Tap to switch"];
            [tapLabel setTextColor:[UIColor whiteColor]];
            [self addSubview:tapLabel];
        } else
        {
            [label setFrame:CGRectMake(-50, 0, 200, 50)];
        }
        
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"calcType"] isEqualToNumber:@0])
            {
                self.type = BTAverage;
            } else
            {
                self.type = BTPluspoints;
            }
        self.semester = [[DataStore defaultStore] currentSemester];
        [self addTarget:class action:@selector(navigationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)update{
    self.semester = [[DataStore defaultStore] currentSemester];

    [self updateText];
}


-(void)changeType{
    self.type = self.type == 0 ? 1 :0;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.type)  forKey:@"calcType"];
    
    //Prüfen, ob der User mehr als 10 mal auf den Button gedrückt hat. Wenn ja, wird das tapLabel entfernt und der counter auf nil
    NSNumber *counter = [[NSUserDefaults standardUserDefaults] objectForKey:@"tapCounter"];
    if (counter)
    {
        if (counter.intValue>10)
        {
            [tapLabel removeFromSuperview];
            tapLabel = nil;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"tapCounter"];
            [label setFrame:CGRectMake(-50, 0, 200, 50)];
        } else
        {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(counter.intValue+1)] forKey:@"tapCounter"];
        }
    }
 

    [self updateText];
}

-(void)updateText{
    switch (self.type)
    {
        case 0:
        {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"Average: %0.2f", nil), [self.semester average]];
            
        }
            break;
            
        case 1:
        {
            //Plus-/Minuspunkte anzeigen
            float pluspoints =[self.semester plusPoints];
            if (pluspoints>=0)
            {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"Pluspoints: %0.1f", nil), pluspoints];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"Minuspoints: %0.1f", nil), -pluspoints];
            }
        }
            break;
        default:
            break;
    }
    
}

@end

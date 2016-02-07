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
        // status speichert '0' oder '1' (Soll Variante 1 (zB. Average) oder Variante 2 (zB. Pluspoints) gezeigt werden)
        // grading speichert integer der 'GradingType-Enumeration', welche der User ausgewählt hat
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"status"] isEqualToNumber:@0])
        {
            self.status = 0;
        } else
        {
            self.status = 1;
        }
        self.semester = [[DataStore defaultStore] currentSemester];
        [self addTarget:class action:@selector(navigationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(int)currentFirstType{
    int grading = (int)[[NSUserDefaults standardUserDefaults]objectForKey:@"grading"];
    switch (grading) {
        case kAverage:
            return BTAverage;
            break;
            
        case kAverageAndPluspoints:
            return BTAverage;
            break;

        default:
            return BTAverage;
            break;
    }
}

-(int)currentSecondType{
    int grading = [[[NSUserDefaults standardUserDefaults]objectForKey:@"grading"] intValue];
    switch (grading) {
        case kAverage:
            return BTAverage;
            break;
            
        case kAverageAndPluspoints:
            return BTPluspoints;
            break;
            
        default:
            return BTAverage;
            break;
    }
}

-(void)update{
    self.semester = [[DataStore defaultStore] currentSemester];
    
    [self updateText];
}


-(void)changeType{
    self.status = self.status == 0 ? 1 :0;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.status)  forKey:@"status"];
    
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
    switch (self.status)
    {
            //Show first type (zB. Average)
        case 0:
        {
            switch ([self currentFirstType])
            {
                case BTAverage:
                    label.text = [self averageString];
                    break;
                    
                default:
                    label.text = [self averageString];
                    break;
            }
        }
            break;
            
            
            
            // Show second Type(zB. Pluspoints, USA, GPA)
        case 1:
        {
            switch ([self currentSecondType])
            {
                case BTAverage:
                    label.text = [self averageString];
                    break;
                    
                case BTPluspoints:
                    label.text = [self plusPointsString];
                    break;
                    
                default:
                    label.text = [self averageString];
                    break;
            }
        }
            //Plus-/Minuspunkte anzeigen
            break;
        default:
            break;
    }
    
}


-(NSString *)averageString{
    return [NSString stringWithFormat:NSLocalizedString(@"Average: %0.2f", nil), [self.semester average]];
}

-(NSString *)plusPointsString{
    float pluspoints =[self.semester plusPoints];
    if (pluspoints>=0)
    {
        return [NSString stringWithFormat:NSLocalizedString(@"Pluspoints: %0.1f", nil), pluspoints];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"Minuspoints: %0.1f", nil), -pluspoints];
    }
    
}

@end

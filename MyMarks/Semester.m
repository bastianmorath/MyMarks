//
//  Semester.m
//  MyMarks
//
//  Created by Bastian Morath on 21/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "Semester.h"
#import "Subject.h"


@implementation Semester
-(float)average{
    NSArray *subjectArray= [[DataStore defaultStore] subjectArray];
    if ([subjectArray count]!=0)
    {
        float countedSubjects=0;
        float tempCount = 0;
        for (Subject *eachSubject in subjectArray)
        {
            if (eachSubject.average!=0 && ![eachSubject.weighting  isEqualToNumber:@0] && eachSubject.average == eachSubject.average)
            {
                countedSubjects++;
                tempCount += eachSubject.average;
            }
        }
        
        if (countedSubjects == 0)
        {
            return 0.0;
        } else{
            return tempCount / countedSubjects;
        }
    } else
    {
        return 0.0;
    }
}


-(float)plusPoints{
    float plusPoints =0;
    for (Subject *eachSubject in [[DataStore defaultStore]subjectArray])
    {
        if ([eachSubject.weighting isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            if(eachSubject.average !=0 && eachSubject.average == eachSubject.average)
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

@dynamic name;
@dynamic subject;

@end

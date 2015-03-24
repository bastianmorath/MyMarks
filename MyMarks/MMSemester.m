//
//  Semester.m
//  MyMarks
//
//  Created by Bastian Morath on 21/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMSemester.h"
#import "MMSubject.h"


@implementation MMSemester

-(float)average{
    NSArray *subjectArray= [[NSArray alloc]initWithArray:[self.subject allObjects]];
    if ([subjectArray count]!=0)
    {
        float countedSubjects=0;
        float tempCount = 0;
        for (MMSubject *eachSubject in subjectArray)
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
    for (MMSubject *eachSubject in self.subject)
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

-(NSString *)USAGrade{
    NSString *string = @"";
    float average = self.average;
    
    if (average >= 5*0.97) {
        string = @"A+";
    }else if (average >= 5*0.93) {
        string = @"A";
    }else if (average >= 5*0.90) {
        string = @"A-";
    }else if (average >= 5*0.87) {
        string = @"B+";
    }else if (average >= 5*0.83) {
        string = @"B";
    }else if (average >= 5*80) {
        string = @"B-";
    }else if (average >= 5*77) {
        string = @"C+";
    }else if (average >= 5*73) {
        string = @"C";
    }else if (average >= 5*0.70) {
        string = @"C-";
    }else if (average >= 5*0.67) {
        string = @"D+";
    }else if (average >= 5*0.63) {
        string = @"D";
    }else if (average >= 5*0.6) {
        string = @"D-";
    }else {
        string = @"F";
    }
    
    return string;

}

@dynamic name;
@dynamic subject;

@end

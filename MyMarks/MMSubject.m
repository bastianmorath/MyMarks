//
//  Subject.m
//  MyMarks
//
//  Created by Bastian Morath on 21/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMSubject.h"
#import "MMExam.h"


@implementation MMSubject

@dynamic name;
@dynamic position;
@dynamic weighting;
@dynamic exam;

-(float)average{
    float  average;
    
    if ([self.exam count] !=0) {
        
        float totalWeighting =0.0;     // Zählt alle Gewichtungen zusammen
        float smallestWeighting = 1.0; // Die kleinste eingegebene Gewichtung
        float totalMarks= 0.0;         // Alle Noten zusammengezählt
        
        // Kleinste Gewichtung suchen:
        for (MMExam * eachExam in self.exam)
        {
            if (eachExam.weighting.floatValue<smallestWeighting && eachExam.weighting.floatValue!=0)
            {
                smallestWeighting = eachExam.weighting.floatValue;
            }
        }
        
        //Gesamtgewichtung und Gesamtnoten werden berechnet
        for (MMExam * eachExam in self.exam)
        {
            if (eachExam.mark) {
                
                totalWeighting +=eachExam.weighting.floatValue/smallestWeighting;
                totalMarks += eachExam.mark.floatValue * eachExam.weighting.floatValue/smallestWeighting;
            }
        }
        
        
        //Durchschnitt berechnen als Gesamtnoten dividiert durch Gesamtgewichtungen
        average = totalMarks / totalWeighting;
    } else {
        average = 0.0;
    }
    
    return average;
}

@end

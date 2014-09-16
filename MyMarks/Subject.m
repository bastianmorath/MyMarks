//
//  Subject.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "Subject.h"
#import "Exam.h"


@implementation Subject

@dynamic name;
@dynamic position;
@dynamic weighting;
@dynamic exam;

-(float)average{
    float  average;
    if ([[self.exam allObjects]count]!=0)
    {
        float totalWeighting =0.0;     // Zählt alle Gewichtungen zusammen
        float smallestWeighting = 1.0; // Die kleinste eingegebene Gewichtung
        float totalMarks= 0.0;         // Alle Noten zusammengezählt
        
        // Kleinste Gewichtung suchen:
        for (Exam * eachExam in self.exam)
        {
            if (eachExam.weighting.floatValue<smallestWeighting & !eachExam.weighting==0)
            {
                smallestWeighting = eachExam.weighting.floatValue;
            }
        }
        
        //Gesamtgewichtung und Gesamtnoten werden berechnet
        for (Exam * eachExam in self.exam)
        {
            totalWeighting +=eachExam.weighting.floatValue/smallestWeighting;
            totalMarks += eachExam.mark.floatValue * eachExam.weighting.floatValue/smallestWeighting;
        }
        
        //Durchschnitt berechnen als Gesamtnoten dividiert durch Gesamtgewichtungen
        average = totalMarks / totalWeighting;
        return average;
    } else
    { //Wenn noch keine Prüfungen hinzugefügt wurden, wird der Durchschnitt auf 0 gesetzt
        return 0;
    }
}

@end

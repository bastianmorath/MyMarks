//
//  Exam.h
//  Notenapplikation
//
//  Created by Bastian Morath on 29/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//
//  Dieses Header-File der Exam-Klasse wurde gemeinsam erstellt

//  Diese Klasse repräsentiert das Objekt "Prüfung" und verwaltet die Note, die Gewichtung, das Datum und die Notizen einer Prüfung

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MMExam : NSManagedObject

@property (nonatomic, retain) NSNumber * mark;      // Dieser Double speichert die Note
@property (nonatomic, retain) NSNumber * weighting; // Dieser Double speichert die Gewichtung
@property (nonatomic, retain) NSDate * date;        // Dieses Datum speichert den Zeitpunkt, wann die Prüfung geschrieben wurde
@property (nonatomic, retain) NSString * notes;     // Dieser String speichert die Notizen zu eienr Prüfung

@end

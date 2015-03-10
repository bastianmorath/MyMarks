//
//  Exam.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.


//  Dieses Header-File der Exam-Klasse wurde gemeinsam erstellt

//  Diese Klasse repräsentiert das Objekt "Prüfung" und verwaltet die Note, die Gewichtung, das Datum und die Notizen einer Prüfung


@interface Exam : NSObject <NSCoding>

@property (nonatomic, assign) double mark;        // Dieser Double speichert die Note
@property (nonatomic, assign) double weighting;   // Dieser Double speichert die Gewichtung
@property (nonatomic, strong) NSString *date;       // Dieses Datum speichert den Zeitpunkt, wann die Prüfung geschrieben wurde
@property (nonatomic, strong) NSString *notes;    // Dieser String speichert die Notizen zu eienr Prüfung

@end

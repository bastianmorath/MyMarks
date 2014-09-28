//
//  Subject.h
//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved

//  Dieses Header-File der Klasse Subject wurde gemeinsam programmiert.

//  Diese Klasse repräsentiert das Objekt "Fach" und verwaltet einen Array mit allen Prüfungen, den Name des Faches und den Durchschnitt



@interface Subject : NSObject <NSCoding>

@property (assign, nonatomic) double average;            // Dieser Double speichert den Durchschnitt des Faches
@property (nonatomic, strong) NSString *subjectName;     // Dieser String enthät den Names des Faches
@property (nonatomic, strong) NSMutableArray *examArray; // Dieser Array enthält Objekte der Klasse "Exam"

@end




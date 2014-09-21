//
//  DataStore.h
//   MyMarks
//
//  Created by Bastian Morath on 28.08.2014.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subject.h"
#import "Exam.h"
#import "Semester.h"
/*
 Die Klasse DataStore verwaltet die CoreData Funktionen des Apps. Sie bietet Möglichkeiten, um Entitys hinzuzufügen und zu löschen.

 */



@interface DataStore : NSObject
{
    NSManagedObjectContext *coreDataContext;
}

+ (DataStore*)defaultStore;

/* Speichert die Daten auf dem Gerät und auch wenn möglich remote. Liefert bei Erfolg TRUE zurück andernfalls FALSE */
- (void)storeData;

/* ------------------ Allgemeine Funktionen ----------------------------------- */
/* Liefert eine Array der "entityName"-Objekcte in der Datenbank zurück. Liefert bei einem Fehler nil zurück */
- (NSArray*)performFetchForEntity:(NSString*)entityName;


/* fügt ein neues Objekt vom Typ <entityName> in die Datenbank ein und liefert es zurück */
- (id)addObjectForName:(NSString*)entityName;

/* löscht ein beliebiges Element aus der Datenbank */
- (void)deleteObject:(NSManagedObject*)object;

/* ------------------  Spezifische Funktionen ----------------------------------- */

-(void)createSubjectWithName:(NSString *)name AndWeighting:(NSNumber*)weighting AndSemester:(Semester *)semester;

-(Semester *)createSemestertWithName:(NSString *)name;
-(Semester *)currentSemester;
//-(Semester *)semesterWithName:(NSString *)name;

-(void)addExamWithData:(NSDictionary *)data ToSubject:(Subject *)subject;

-(NSArray *)subjectArray;
-(NSArray *)semesterArray;
-(NSArray *)examArrayForSubject:(Subject *)subject;

@end
//
//  DataStore.m
//   MyMarks
//
//  Created by Bastian Morath on 28.08.2014.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//
#import "DataStore.h"


// Singleton Instanz der Klasse
static DataStore *defaultStore;


@implementation DataStore

// Singleton Funktionen
+ (DataStore*)defaultStore
{
    if (!defaultStore)
    {
        defaultStore = [[super allocWithZone:nil]init];
    }
    return defaultStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return defaultStore;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        if (![self initCoreData])
        {
            return nil;
        }
    }
    return self;
}


/* Initialisiert CoreData */
- (Boolean)initCoreData
{
    NSError *error;
    
    // Pfad zur Datendatei
    NSURL *url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/data.db"]];

    
    // Initialisiere Modell und Kontext
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

    NSPersistentStoreCoordinator *persistenStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObjectModel];
    
    
    if ( ![persistenStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error] )
    {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        NSLog(@"Deleted old database %@, %@", error, [error userInfo]);
        [persistenStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:@{NSMigratePersistentStoresAutomaticallyOption:@YES} error:&error];
        
        NSLog(@"Error: %@", [error localizedFailureReason]);
        
    }
    else
    {
        coreDataContext = [[NSManagedObjectContext alloc]init];
        [coreDataContext setPersistentStoreCoordinator:persistenStoreCoordinator];
    }
    
    return true;
}

#pragma mark - Object_Managing

- (id)addObjectForName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:coreDataContext];
}

- (NSFetchedResultsController*)performFetchForAttribute:(NSString *)attributeName OfObject:(NSString *)objectName
{
    
    // Abfrageanforderung
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:objectName inManagedObjectContext:coreDataContext]];
    
    
    // Sortierung
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:attributeName ascending:YES selector:nil];
    NSArray *descriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSError *error = nil;
    NSFetchedResultsController *fRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    if (![fRC performFetch:&error])
    {
        NSLog(@"Error: %@", [error localizedFailureReason]);
        return nil;
    }
    return fRC;
}

- (NSArray*)performFetchForEntity:(NSString *)entityName
{
    return [self performFetchForEntity:entityName WithPredicate:nil AndSortDescriptor:nil];
}

- (NSArray*)performFetchForEntity:(NSString *)entityName WithPredicate:(NSPredicate *)predicate AndSortDescriptor:(NSArray *)sDescriptors
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:coreDataContext]];
    [request setPredicate:predicate];
    [request setSortDescriptors:sDescriptors];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *array = [coreDataContext executeFetchRequest:request error:&error];
    
    if (error!=nil)
    {
        NSLog(@"Error: %@", [error localizedFailureReason]);
    }
    
    return array;
}


-(void)storeData
{
    NSError *error;
    if ([coreDataContext hasChanges]) {
        if (![coreDataContext save:&error])
        {
            NSLog(@"Error: %@", [error localizedFailureReason]);
        }
    }
}

- (void)deleteObject:(NSManagedObject *)object
{
    [coreDataContext deleteObject:object];
    [self storeData];
}

/* ------------------  Spezifische Funktionen ----------------------------------- */


-(MMSubject *)createSubjectWithName:(NSString *)name AndWeighting:(NSNumber*)weighting AndSemester:(MMSemester *)semester
{
    MMSubject *subject = [self addObjectForName:@"MMSubject"];
    subject.name= name;
    if (weighting)
    {
        subject.weighting = weighting;
    } else {
        subject.weighting = @1;
    }
    //Die Prüfung wird an letzter Position eingefügt
    subject.position = [NSNumber numberWithInt:[[self subjectArray]count]];
    
    //Die prüfung wird dem Semester hinzugefügt
    [semester addSubjectObject:subject];
    [self storeData];
    
    return subject;
}

-(MMSemester *)createSemestertWithName:(NSString *)name
{
    MMSemester *semester = [self addObjectForName:@"MMSemester"];
    semester.name = name;
    
    [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"semester"];

    [self storeData];
    
    return semester;
}

-(MMSemester *)semesterWithName:(NSString *)name{
    
    return nil;
}

-(MMSemester *)currentSemester
{
    for (MMSemester *semester in [self semesterArray])
    {
        if ([semester.name isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"semester"]])
        {
            return semester;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Semester 1" forKey:@"semester"];

    return [[DataStore defaultStore] createSemestertWithName:@"Semester 1"];
}


-(void)addExamWithData:(NSDictionary *)data ToSubject:(MMSubject *)subject
{
    
    MMExam *exam = [self addObjectForName:@"MMExam"];
    exam.mark = [data objectForKey:@"mark"];
    exam.weighting = [data objectForKey:@"weighting"];
    exam.date = [data objectForKey:@"date"];
    exam.notes = [data objectForKey:@"notes"];
    
    [subject addExamObject:exam];
    [self storeData];
}

-(NSArray *)subjectArray
{
    
    NSSortDescriptor *sDescriptor = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
    NSArray *descriptors = @[sDescriptor];
    NSArray *subjects =[self performFetchForEntity:@"MMSubject" WithPredicate:nil AndSortDescriptor:descriptors];
    MMSemester *currentSemester= [self currentSemester];
    NSMutableArray *subjectsForCurrentSemester = [[NSMutableArray alloc]init];
    for (MMSubject *subject in subjects) {
        if ([currentSemester.subject containsObject:subject])
        {
            [subjectsForCurrentSemester addObject:subject];
        }
    }
    
    return subjectsForCurrentSemester;
}

-(NSArray *)semesterArray
{
    NSSortDescriptor *sDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *descriptors = @[sDescriptor];
    return [self performFetchForEntity:@"MMSemester" WithPredicate:nil AndSortDescriptor:descriptors];
}

-(NSArray *)examArrayForSubject:(MMSubject *)subject
{
    NSArray *exams =[self performFetchForEntity:@"MMExam" WithPredicate:nil AndSortDescriptor:nil];
    NSMutableArray *examsForCurrentSubject = [[NSMutableArray alloc]init];
    for (MMExam  *exam in exams) {
        if ([subject.exam containsObject:exam])
        {
            [examsForCurrentSubject addObject:exam];
        }
    }
    
    return examsForCurrentSubject;
}


@end
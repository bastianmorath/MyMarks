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
    if (!defaultStore){
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
    if (self){
        if (![self initCoreData]){
            return nil;
        }
        // Debugging Objekte erstellen
        //[self createSomeObjects];
    }
    return self;
}


/* Initialisiert CoreData */
- (Boolean)initCoreData
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"Info: Core Data wurde initialisiert");
    
    return true;
}

#pragma mark -
#pragma mark Object_Managing
- (void)removeManagedObject:(id)object
{
    [coreDataContext deleteObject:object];
}

- (id)addObjectForName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:coreDataContext];
}

- (NSFetchedResultsController*)performFetchForAttribute:(NSString *)attributeName OfObject:(NSString *)objectName
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Abfrageanforderung
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:objectName inManagedObjectContext:coreDataContext]];
    
    
    // Sortierung
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:attributeName ascending:YES selector:nil];
    NSArray *descriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    
    NSError *error = nil;
    NSFetchedResultsController *fRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    if (![fRC performFetch:&error]){
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
    
    NSError *error = nil;
    NSArray *array = [coreDataContext executeFetchRequest:request error:&error];
    
    if (error!=nil){
        NSLog(@"Error: %@", [error localizedFailureReason]);
    }
    
    return array;
}


- (BOOL)storeData
{
    
    // Daten zum Speichern auf dem Server an den NetworkStore übergeben
    // [[NetworkStore defaultStore]syncObjects:[coreDataContext updatedObjects]];
    
    NSError *error;
    if ( ![coreDataContext save:&error])
    {
        NSLog(@"Error: %@", [error localizedFailureReason]);
        return NO;
    }
    return YES;
}
- (void)deleteObject:(NSManagedObject *)object
{
    [coreDataContext deleteObject:object];
    [self storeData];
}

/* ------------------  Spezifische Funktionen ----------------------------------- */


-(void)createSubjectWithName:(NSString *)name AndWeighting:(float)weighting AndSemester:(Semester *)semester{
    Subject *subject = [self addObjectForName:@"Subject"];
    subject.name= name;
    if (weighting) {
        subject.weighting = [NSNumber numberWithFloat:weighting];
    } else {
        subject.weighting = @1;
    }
    //Die Prüfung wird an letzter Position eingefügt
    subject.position = [NSNumber numberWithInt:[[self getSubjects]count]-1];
    
    //Die prüfung wird dem Semester hinzugefügt
    [semester addSubjectObject:subject];
    [self storeData];
}

-(Semester *)createSemestertWithName:(NSString *)name{
    Semester *semester = [self addObjectForName:@"Semester"];
    semester.name = name;
    [self storeData];
    
    return semester;
}
-(void)addExamWithData:(NSDictionary *)data ToSubject:(Subject *)subject{
    
    Exam *exam = [self addObjectForName:@"Exam"];
    exam.mark = [data objectForKey:@"mark"];
    exam.weighting = [data objectForKey:@"weighting"];
    exam.date = [data objectForKey:@"date"];
    exam.notes = [data objectForKey:@"notes"];
    
    [subject addExamObject:exam];
    NSLog(@"Exam: %@", exam);
    [self storeData];
}

-(NSArray *)getSubjects{
    NSSortDescriptor *sDescriptor = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
    NSArray *descriptors = @[sDescriptor];
    return [self performFetchForEntity:@"Subject" WithPredicate:nil AndSortDescriptor:descriptors];

}

-(NSArray *)getSemesters{
    NSSortDescriptor *sDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *descriptors = @[sDescriptor];
    return [self performFetchForEntity:@"Semester" WithPredicate:nil AndSortDescriptor:descriptors];
}


@end
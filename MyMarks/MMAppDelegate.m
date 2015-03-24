//
//  AppDelegate.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AppDelegate-Klasse wurde von Florian erstellt

#import "MMAppDelegate.h"
#
@implementation MMAppDelegate

NSString * const Version_1_1_1 = @"1.1.1";
NSString * const Version_1_1_2 = @"1.1.2";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //**Google Analytics**//
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 30;

    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54555153-1"];

    [MMFactory initGoogleAnalyticsForClass:self];

    // initialize AppbotX
    [[ABXApiClient instance] setApiKey:@"45882cbaa8578c8a77dd93a1ee2ae33652348a24"];

    
    //Diese Methode wird nur das aller erste Mal im "Lebenszyklus" der App durchlaufen. Es werden vordefinierte Fächer hinzugefügt.
    /*Dispatch once*/

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Started"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Started"];
        
        // Grading-Type: 0 als default-Value setzen ( Es wird der Durchschnitt angezeigt
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"grading"];

        //Wenn der User mehr als 10 mal den Button im MMSubjectVC drückt, wir der entfernt
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"tapCounter"];

        
        if ([[[DataStore defaultStore]semesterArray] count] == 0) {
            [[DataStore defaultStore] createSemestertWithName:@"Semester 1"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Semester 1" forKey:@"semester"];
        }
        
        //**Google Analytics**//
        
        // May return nil if a tracker has not already been initialized with a
        // property ID.
        id tracker = [[GAI sharedInstance] defaultTracker];
      
        [tracker setAllowIDFACollection:YES];
        // This screen name value will remain set on the tracker and sent with
        // hits until it is set to a new value or to nil.
        [tracker set:kGAIScreenName
               value:@"New User: App Delegate"];
        
        // New SDK versions
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        
        // Wenn der User die App geupdatet hat, weise ihn auf die neuen Funktionen hin. Wenn ein User die App das erste Mal herunterladet, zeige kein AlertView
        if([[NSUserDefaults standardUserDefaults] boolForKey:Version_1_1_1] == YES && ![[NSUserDefaults standardUserDefaults] boolForKey:Version_1_1_2]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Version_1_1_2];
            [self showUpdateAlertView];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Version_1_1_1];

    }

    
    

    
    //Farbe der Navigation-Bar wird auf blau gesetzt
    [[UINavigationBar appearance]setBarTintColor:[MMFactory blueColor]];
    
    //Zeigt die Statusbarsymbole in weisser Schrift an
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

#pragma mark - Alert View

-(void)showUpdateAlertView{
    NSString *message = NSLocalizedString(@"Update message", nil);
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MyMarks 1.1.2", nil)
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                        otherButtonTitles:nil];
    [alert setAlertViewStyle: UIAlertViewStyleDefault];
    [alert show];

}


//Diese Methode überträgt die bisherigen Subjects (welche mit NSUserDefaults erstellt wurden) in das CoreDataModel
-(void)updateDataModel{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"savedArray"];
    NSArray *subjectArray;
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
        {
            subjectArray= [[NSMutableArray alloc] initWithArray:oldSavedArray];
            MMSemester *semester= [[DataStore defaultStore]createSemestertWithName:@"Backup"];
            for (Subject *subject in subjectArray) {
                MMSubject *newSubject = [[DataStore defaultStore]createSubjectWithName:subject.subjectName AndWeighting:@1 AndSemester:semester];
                for (Exam *exam in subject.examArray) {
            
                    NSLog(@"Mark:%f", exam.mark);
                    NSLog(@"Weihting:%f", exam.weighting);
                    NSLog(@"Date:%@", exam.date);
                    NSLog(@"Notes:%@", exam.notes);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           
                    [dateFormatter setDateFormat:@"EdMMM"];
                    NSDate *date = [dateFormatter dateFromString:exam.date];
                    
                    if (!date) {
                        date = [NSDate date];
                    }
                    if (!exam.notes) {
                        exam.notes = @"";
                    }
                    
                      NSDictionary *dict = @{@"mark": [NSNumber numberWithDouble:exam.mark],
                                           @"weighting":[NSNumber numberWithDouble:exam.weighting] ,
                                           @"date" : date,
                                           @"notes": exam.notes
                                           };
                    [[DataStore defaultStore] addExamWithData:dict ToSubject:newSubject];
                }
            }
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{ // Diese Methode wird aufgerufen, wenn die Applikation in den Hintergrund tritt. Hier werden zum Beispiel die Daten gespeichert.
    
    [[DataStore defaultStore] storeData];
}


@end

//
//  AppDelegate.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AppDelegate-Klasse wurde von Florian erstellt

#import "MMAppDelegate.h"

@implementation MMAppDelegate


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

    
    //Diese Methode wird nur das aller erste Mal im "Lebenszyklus" der App durchlaufen. Es werden vordefinierte Fächer hinzugefügt.
    /*Dispatch once*/
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"tapCounter"];

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Started"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Started"];
        
        //Wenn der User mehr als 10 mal den Buton im MMSubjectVC drückt, wir der entfernt
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"tapCounter"];

        [[DataStore defaultStore] createSemestertWithName:@"Semester 1"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Semester 1" forKey:@"semester"];
        [MMFactory initGoogleAnalyticsForClass:self];

        [self showUpdateAlertView];
        [self updateDataModel];
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
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MyMarks 1.1", nil)
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
        }
    }
    
    MMSemester *semester= [[DataStore defaultStore]createSemestertWithName:@"Old Semester"];
    for (Subject *subject in subjectArray) {
        MMSubject *newSubject = [[DataStore defaultStore]createSubjectWithName:subject.subjectName AndWeighting:@1 AndSemester:semester];
        for (Exam *exam in subject.examArray) {
            NSDictionary *dict = @{@"mark": [NSNumber numberWithDouble:exam.mark],
                                   @"weighting":[NSNumber numberWithDouble:exam.weighting],
                                   @"date" : exam.date,
                                   @"notes":exam.notes
                                   };
           [[DataStore defaultStore] addExamWithData:dict ToSubject:newSubject];
        }
    }
}

@end

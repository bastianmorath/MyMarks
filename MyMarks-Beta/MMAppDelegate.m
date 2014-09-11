//
//  AppDelegate.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AppDelegate-Klasse wurde von Florian erstellt

#import "MMAppDelegate.h"

@implementation MMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
       
    //Diese Methode wird nur das aller erste Mal im "Lebenszyklus" der App durchlaufen. Es werden vordefinierte Fächer hinzugefügt.
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [[NSUserDefaults standardUserDefaults] setObject:@"Average" forKey:@"calculationType"];
        
        //calcType bestimmt, ob der User den Durchschnitt oder die PLuspunkte anzeigen will,
        // Object für Key Average: 0
        // Object für Key Pluspoints: 1
        //Average by Default
        //[[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"calcType"];
        
        }
     );
    
    
    //Farbe der Navigation-Bar wird auf blau gesetzt
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:40/255.0f green:119/255.0f blue:235/255.0f alpha:1]];
    
    //Zeigt die Statusbarsymbole in weisser Schrift an
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //**Google Analytics**//
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 30;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54555153-1"];
    return YES;
}




@end

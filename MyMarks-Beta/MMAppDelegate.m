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
    /*Dispatch once*/
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Started"])
    {
        NSLog(@"Started");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Started"];
        
        //Wenn der User mehr als 10 mal den Buton im MMSubjectVC drückt, wir der entfernt
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"tapCounter"];

        [[DataStore defaultStore] createSemestertWithName:@"Semester 1"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Semester 1" forKey:@"semester"];
    }

    
    //Farbe der Navigation-Bar wird auf blau gesetzt
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:20/255.0f green:120/255.0f blue:261/255.0f alpha:1]];
    
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

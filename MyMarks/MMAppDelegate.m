//
//  AppDelegate.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AppDelegate-Klasse wurde von Florian erstellt

#import "MMAppDelegate.h"
#
@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Diese Methode wird nur das aller erste Mal im "Lebenszyklus" der App durchlaufen. Es werden vordefinierte Fächer hinzugefügt.
    /*Dispatch once*/

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Started"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Started"];
        
        // Grading-Type: 0 als default-Value setzen ( Es wird der Durchschnitt angezeigt
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"grading"];

        //Wenn der User mehr als 10 mal den Button im MMSubjectVC drückt, wir der entfernt
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"tapCounter"];

        
        if ([[[DataStore defaultStore]semesterArray] count] == 0) {
            [[DataStore defaultStore] createSemestertWithName:@"Semester 1"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Semester 1" forKey:@"semester"];
        }
        
        // Set Grading: Average + Pluspoints as default
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"grading"];
    }

    
    

    
    //Farbe der Navigation-Bar wird auf blau gesetzt
    [[UINavigationBar appearance]setBarTintColor:[MMFactory blueColor]];
    
    //Zeigt die Statusbarsymbole in weisser Schrift an
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{ // Diese Methode wird aufgerufen, wenn die Applikation in den Hintergrund tritt. Hier werden zum Beispiel die Daten gespeichert.
    
    [[DataStore defaultStore] storeData];
}


@end

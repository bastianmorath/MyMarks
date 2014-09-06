//
//  AppDelegate.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AppDelegate-Klasse wurde von Florian erstellt

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
       
    //Diese Methode wird nur das aller erste Mal im "Lebenszyklus" der App durchlaufen. Es werden vordefinierte Fächer hinzugefügt.
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"calculationType"];
        
        //calcType bestimmt, ob der User den Durchschnitt oder die PLuspunkte anzeigen will,
        // Object für Key Average: 0
        // Object für Key Pluspoints: 1
        //Average by Default
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"calcType"];

    }
     );

    
    //Farbe der Navigation-Bar wird auf blau gesetzt
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:40/255.0f green:119/255.0f blue:235/255.0f alpha:1]];
    
    //Zeigt die Statusbarsymbole in weisser Schrift an
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    return YES;
}




@end

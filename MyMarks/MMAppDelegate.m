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

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self exportMarks];
}


#pragma mark - E-Mail

- (void)exportMarks
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
    
    //Alle Prüfungen werden in einem NSMtableString aufgelistet
    NSMutableString *writeString = [[NSMutableString alloc]init];
    writeString = [NSMutableString string];
    [writeString appendString:@"MyMarks \n \n"];
    
    //Note, gewichtung, Datum und Notizen einer Prüfung werden dem NSMutableString angehängt
    for (Semester *semester in [[DataStore defaultStore]semesterArray])
    {
        [writeString appendString:[NSString stringWithFormat:@"\n\n%@\n ",semester.name]];
        
        for (int i=0; i<[semester.subject count]; i++)
        {
            Subject *subject = [[semester.subject allObjects] objectAtIndex:i];
            [writeString appendString:[NSString stringWithFormat:@"\n\n%@\n ",subject.name]];
            
            for (Exam *eachExam in [subject.exam allObjects])
            {
                [writeString appendString:[NSString stringWithFormat:
                                           @"Note: \t%0.2f       Gewichtung: \t%0.2f       Datum:\t %@       Notizen:  \t%@ \n\n",
                                           eachExam.mark.floatValue, eachExam.weighting.floatValue, eachExam.date, eachExam.notes]];
            }
            [writeString appendString:@"\t\n\n"];
        }
        
    }
    
    
    NSFileHandle *handle;
    //Sagt, wo das File gelesen werden soll
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    //Stellt den Cursor ans Ende des Files
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Ein Controller für das Mail-Programm wird erstellt und aufgerufen
     self.globalMailComposer = [[MFMailComposeViewController alloc] init];
    [self.globalMailComposer.view setTintColor:[UIColor whiteColor]];
    self.globalMailComposer.mailComposeDelegate = self;
    [self.globalMailComposer setSubject:@"MyMarks"];
    [self.globalMailComposer addAttachmentData:[NSData dataWithContentsOfFile:[self dataFilePath] ]
                     mimeType:@"text/csv"
                     fileName:@"MyMarks.csv"];
    [self.window.rootViewController presentViewController:self.globalMailComposer animated:YES completion:nil];
    self.globalMailComposer = nil;
    self.globalMailComposer = [[MFMailComposeViewController alloc] init];
}


//Exportieren einer csv-Datei
-(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
}


//Diese Methode kontrolliert das Resulat des Mail-Vorganges und gibt bei einem Error eine Meldung aus
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    
    {
        case MFMailComposeResultCancelled:
            
            NSLog(@"Mail abgebrochen");
            
            break;
            
        case MFMailComposeResultSaved:
            
            NSLog(@"Mail gespeichert");
            
            break;
            
        case MFMailComposeResultSent:
            
            NSLog(@"Mail gesendet");
            
            break;
            
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail senden fehlgeschlagen: %@", [error localizedDescription]);
            
            break;
            
        default:
            
            break;
    }
    
    // Schliesst den View des Mails
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}


@end

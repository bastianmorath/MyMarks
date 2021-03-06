//
//  AppDelegate.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Header-File der AppDelegate-Klasse wurde gemeinsam erstellt

//  Dieser Controller ist dazu da, um die Daten beim Öffnen und Schliessen der App zu speichern, bzw. zu laden. 


#import "Subject.h"
#import "Exam.h"
#import <MessageUI/MessageUI.h>


@interface MMAppDelegate : UIResponder <UIApplicationDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

@end

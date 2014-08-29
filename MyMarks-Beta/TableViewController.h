//
//  TableViewController.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights
//

//  Dieses Header-File der TableViewController-Klasse wurde gemeinsam erstellt. Das heisst, wir haben uns zusammen überlegt, welche Methoden und Properties nötig sind, haben sie aber gemischt implementiert (siehe TableViewController.m)


//  Dieser Controller verwaltet den TableView, welcher die Fächer auflistet.


#import <MessageUI/MessageUI.h>
#import "DetailViewController.h"
#import "Subject.h"


@interface TableViewController : UITableViewController <UITableViewDelegate, UIAlertViewDelegate, UIApplicationDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>


@property (assign, nonatomic) double plusPoints;


-(NSArray *)getSubjectArray;

- (void)editPressed;
- (void)donePressed;


@end

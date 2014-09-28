//
//  TableViewController.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights
//

//  Dieses Header-File der TableViewController-Klasse wurde gemeinsam erstellt. Das heisst, wir haben uns zusammen überlegt, welche Methoden und Properties nötig sind, haben sie aber gemischt implementiert (siehe TableViewController.m)


//  Dieser Controller verwaltet den TableView, welcher die Fächer auflistet.


#import <MessageUI/MessageUI.h>
#import "MMExamsVC.h"
#import "MMSubject.h"
#import "MMNavigationViewButton.h"


@interface MMSubjectsVC : UITableViewController <UITableViewDelegate, UIAlertViewDelegate, UIApplicationDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>



@property (nonatomic, strong) MMNavigationViewButton *navigationViewButton;
@property (nonatomic, strong) MMSemester *semester;

@property (nonatomic, strong) NSArray *subjectArray;
-(void)updateSubjectArray;

- (void)editPressed;
- (void)donePressed;


@end

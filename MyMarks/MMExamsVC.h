//
//  DetailViewController.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.


//  Dieses Header-File der DetailViewController-Klasse wurde gemeinsam erstellt. Das heisst, wir haben uns zusammen überlegt, welche Methoden und Properties nötig sind, haben sie aber gemischt implementiert (siehe DetailViewController.m)

//  Dieser Controller verwaltet die Pruefungen und der Durchschnitt eines faches in einem TableView


#import "Exam.h"
#import "MMAddExamVC.h"
#import "Subject.h"

@interface MMExamsVC : UITableViewController


@property (strong, nonatomic) Subject *subject;

-(NSArray *)exams;

-(IBAction)editPressed:(id)sender;
-(IBAction)donePressed:(id)sender;


@end

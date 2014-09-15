//
//  AddExamController.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Header-File der AddExamController-Klasse wurde von Bastian erstellt

//  Diese Klasse verwaltet den Controller, welcher eine neue Prüfung erstellt.

#import <QuartzCore/QuartzCore.h>
#import "Exam.h"


@interface MMAddExamVC : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIScrollViewDelegate>
{
    UIColor *color1;
    UIColor *color2;
    UIColor *color3;
    UIColor *color4;
}
@property (strong, nonatomic) Exam *exam; //Die Prüfung, die bearbeitet/erstellt wird
@property (strong, nonatomic) Subject *subject; //Das Fach, zu welchem die Prüfung hinzugefügt wird


@property (strong, nonatomic) IBOutlet UITextField *MarkTextField;
@property (strong, nonatomic) IBOutlet UITextField *WeightingTextField;
@property (strong, nonatomic) IBOutlet UITextField *DateTextField;
@property (strong, nonatomic) IBOutlet UITextView  *NotesTextField;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic)   IBOutlet UIDatePicker *datePicker;


- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@end

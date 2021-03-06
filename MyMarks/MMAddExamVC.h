//
//  AddExamController.h

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Header-File der AddExamController-Klasse wurde von Bastian erstellt

//  Diese Klasse verwaltet den Controller, welcher eine neue Prüfung erstellt.

#import <QuartzCore/QuartzCore.h>
#import "UIFloatLabelTextField.h"
#import "UIFloatLabelTextView.h"
#import "MMExam.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MMAddExamVC : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
{
    UIColor *color1;
    UIColor *color2;
    UIColor *color3;
    UIColor *color4;
    UIDatePicker *datePicker;

}
@property (strong, nonatomic) MMExam *exam; //Die Prüfung, die bearbeitet/erstellt wird
@property (strong, nonatomic) MMSubject *subject; //Das Fach, zu welchem die Prüfung hinzugefügt wird


@property  UIFloatLabelTextField *MarkTextField;
@property  UIFloatLabelTextField *WeightingTextField;
@property  UIFloatLabelTextField *DateTextField;
@property  UIFloatLabelTextView  *NotesTextField;

@property (strong, nonatomic)  MMBarButtonItem *doneBarButton;

@end

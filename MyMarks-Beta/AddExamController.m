//
//  AddExamController.m
//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AddExamController-Klasse wurde von Bastian erstellt


#import "AddExamController.h"

@implementation AddExamController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.exam = [[Exam alloc]init];
        self.exam.mark = 0;
        [self.datePicker setHidden:YES];
        [self.DateTextField setDelegate:self];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    //Wenn  im DetailViewController auf eine bereits vorhandene Prüfung gedrückt wird, um sie zu editieren, werden hier die TextFields entsprechend ausgefüllt
    if (self.exam)
    {
        self.MarkTextField.text = [NSString stringWithFormat:@"%.2f", self.exam.mark.floatValue];
        self.WeightingTextField.text = [NSString stringWithFormat:@"%.2f", self.exam.weighting.floatValue];
        self.DateTextField.text = [MMFactory NSStringFromDate:self.exam.date];
        self.NotesTextField.text = [NSString stringWithFormat:@"%@", self.exam.notes];
        self.doneBarButton.enabled = YES;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //Für alle TextFields jeweils: transparenter Background, weisser Rand und Keyboard translucent machen
    self.MarkTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.MarkTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.MarkTextField.layer.borderWidth = 1.0;
    self.MarkTextField.layer.cornerRadius = 0.0f;
    
    self.DateTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.DateTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.DateTextField.layer.borderWidth = 1.0;
    self.DateTextField.layer.cornerRadius = 0.0f;
    
    //Aktueller Tag als Default-Date einsetzen
    self.DateTextField.text = [MMFactory NSStringFromDate:[NSDate date]];
    
    
    self.WeightingTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.WeightingTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.WeightingTextField.layer.borderWidth = 1.0;
    self.WeightingTextField.layer.cornerRadius = 0.0f;
    
    //Notizen-Field wird initialisiert mit einem Border und runden Ecken
    self.NotesTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.NotesTextField.layer.borderWidth = 1.0f;
    self.NotesTextField.layer.cornerRadius = 0;
    self.NotesTextField.layer.borderColor =[[UIColor whiteColor] CGColor];
    
    //Navigation-Title auf weisse Schrift setzen
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    //Barbutton-Items weiss einfärben
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
    //DatePicker wird versteckt und der Done-Button wird deaktiviert
    [self.datePicker setHidden:YES];
     self.doneBarButton.enabled = NO;
    
}



#pragma mark - DatePicker

//Diese Methode ist da, damit der DatePicker erkannt wird; Sie ist aber leer
-(IBAction)datePicker:(id)sender{
}


//Wenn im DatePicker das Datum geändert wird, wird der Text im Datum-Field entsprechend geändert
- (void)changeDate:(UIDatePicker *)sender
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CH"];
    NSString *date = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:usLocale];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = date;
    
    self.DateTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:sender.date]];
}


//Diese Methode wird aufgerufen, wenn der DatePicker verschwinden soll
- (void)dismissDatePicker:(id)sender
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    
    [UIView commitAnimations];
}


//Diese Methode entfernt die Views des DatePickers
- (void)removeViews:(id)object
{
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"DATEPICKER should begin editing");
    //Wenn noch kein Datum eingetragen ist, wird das Datum vom aktuellen Tag eingetragen
    if (textField==self.DateTextField && [self.DateTextField.text length]==0)
    {
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CH"];
        NSString *date = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0 locale:usLocale];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = date;
        
        self.DateTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:self.datePicker.date]];
    }
    return YES;
}


//Diese Methode wird aufgerufen, wenn das Datum des DatePickers geändert wird
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode= UIDatePickerModeDate;
    datePicker.tag = 10;
    
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    //Das aktuelle Datum des DatePickers wird im TextFeld angezeigt
    self.DateTextField.inputView = datePicker;
}



#pragma mark - TextField delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Der Done-Button kann nur dann gedrückt werden, wenn im Noten-Feld eine Zahl eingetragen ist
    NSInteger textLength = [textField.text length] - range.length + [string length];
    if (textLength > 0)
    {
        self.doneBarButton.enabled = YES;
    }
    else
    {
        self.doneBarButton.enabled = NO;
    }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //Wenn der Return-Button auf dem Keyboard gedrückt wird, verschwindet das Keyboard
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}



#pragma mark - Table View data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    
    //Einen Farbverlauf von Blau nach Grün wird erstellt
    double redColor =   41  + (indexPath.row * 116/9);
    double greenColor = 135 + (indexPath.row * 94/9);
    double blueColor =  241 - (indexPath.row * 110/9);
    NSLog(@"Red: %f, Green: %f, Blue: %f", redColor, greenColor, blueColor);
    cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    if (indexPath.row ==1)
    {
        color1 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
        NSLog(@"Color1: %@", color1);
    }
    if (indexPath.row ==2)
    {
        color2 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
        NSLog(@"Color2: %@", color2);

    }
    if (indexPath.row ==3)
    {
        color3 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
        NSLog(@"Color3: %@", color3);
    }
    if (indexPath.row ==4)
    {
        color4 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
        NSLog(@"Color4: %@", color4);
    }
    
    self.MarkTextField.backgroundColor = color1;
    self.WeightingTextField.backgroundColor = color2;
    self.DateTextField.backgroundColor =color3;
    self.NotesTextField.backgroundColor = color4;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


//Gibt die Anzahl Rows in Abhängigkeit von der Displaygrösse zurück
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    bool isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136));
    if (isiPhone5)
    {
        return 9;
    } else
    {
        return 8;
    }
}


//Gibt die Höhe einer Row in Abhängigkeit von der Displaygrösse zurück
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bool isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136));
    if (!isiPhone5)
    {
        //Höhe wird so gesetzt, dass gerade 10 Rows Platz haben
        if (indexPath.row ==3)
        {
            return 2*[[UIScreen mainScreen] bounds].size.height/10-1.3;
        }
        return [[UIScreen mainScreen] bounds].size.height/10-1.0;
    }else
    {
    //Höhe wird so gesetzt, dass gerade 10 Rows Platz haben
        if (indexPath.row ==3)
        {
            return 2*[[UIScreen mainScreen] bounds].size.height/11-1.3;
        }
    return [[UIScreen mainScreen] bounds].size.height/11-1.0;
    }
}


#pragma mark - Buttons

- (IBAction)donePressed:(id)sender
{
    
    NSNumber *mark = [NSNumber numberWithDouble:[self.MarkTextField.text doubleValue]];
    NSNumber *weighting;
    if ([self.WeightingTextField.text doubleValue]==0)
    {
        weighting =@1;
    } else
    {
        weighting = [NSNumber numberWithDouble:[self.WeightingTextField.text doubleValue]];
    }
    
    if ([self.subject.exam containsObject:self.exam]) { //Exam wurde bearbeitet
        self.exam.mark = mark;
        self.exam.weighting = weighting;
        self.exam.date = [MMFactory NSDateFromString:self.DateTextField.text];
        self.exam.notes = self.NotesTextField.text;
    } else {
        //Neue Exam wurde erstellt
        NSDictionary *dict = @{@"mark": mark,
                               @"weighting":weighting,
                               @"date" : [MMFactory NSDateFromString:self.DateTextField.text],
                               @"notes":self.NotesTextField.text
                               };
        
        [[DataStore defaultStore] addExamWithData:dict ToSubject:self.subject];

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

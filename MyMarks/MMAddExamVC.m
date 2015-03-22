//
//  AddExamController.m
//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der AddExamController-Klasse wurde von Bastian erstellt


#import "MMAddExamVC.h"

@implementation MMAddExamVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIFloatLabelTextField appearance] setBackgroundColor:[UIColor whiteColor]];
    
    
    
    //Navigation-Title auf weisse Schrift setzen
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    //Barbutton-Items weiss einfärben
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
    
    
    //Linkes BarButtonItem setzen
    [self.navigationItem setLeftBarButtonItem:[[MMBarButtonItem alloc]initWithText:NSLocalizedString(@"Cancel", nil)  target:self Position:PTLeft] animated:YES];
    
    //Rechtes BarButtonItem setzen
    self.doneBarButton = [[MMBarButtonItem alloc]initWithText:NSLocalizedString(@"Done", nil) target:self Position:PTRight];
    [self.navigationItem setRightBarButtonItem:self.doneBarButton animated:YES];
    
    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Add exam", nil)];
    
    //Schwarzer Strich am unteren Ende der Navigationbar entfernen
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    // TextFields
    [self setupTextFields];
    
    //Wenn  im DetailViewController auf eine bereits vorhandene Prüfung gedrückt wird, um sie zu editieren, werden hier die TextFields entsprechend ausgefüllt
    if (self.exam)
    {
        self.MarkTextField.text = [NSString stringWithFormat:@"%.2f", self.exam.mark.floatValue];
        self.WeightingTextField.text = [NSString stringWithFormat:@"%.2f", self.exam.weighting.floatValue];
        
        
        self.DateTextField.text = [MMFactory NSStringFromDate:self.exam.date];
        self.NotesTextField.text = [NSString stringWithFormat:@"%@", self.exam.notes];
        self.doneBarButton.enabled = YES;
    }
    
    //Done-Button wird deaktiviert
    [self updateDoneBarButton];
    
    //**Google Analytics**//
    [MMFactory initGoogleAnalyticsForClass:self];
}

-(void)setupTextFields{
    self.MarkTextField = [UIFloatLabelTextField new];
    self.MarkTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.MarkTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.MarkTextField.delegate = self;
    
    self.WeightingTextField = [UIFloatLabelTextField new];
    self.WeightingTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.WeightingTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.WeightingTextField.delegate = self;
    
    self.DateTextField = [UIFloatLabelTextField new];
    self.DateTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.DateTextField.delegate = self;
    
    self.NotesTextField = [UIFloatLabelTextView new];
    self.NotesTextField.placeholderTextColor = [UIColor colorWithRed:55/255.0f green:130/255.f blue:200/255.0f alpha:1];
    self.NotesTextField.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissDatePicker:datePicker];
    [self.MarkTextField resignFirstResponder];
    [self.WeightingTextField resignFirstResponder];
    [self.DateTextField resignFirstResponder];
    [self.NotesTextField resignFirstResponder];
}

-(void)updateDoneBarButton{
    NSInteger textLength =[self.MarkTextField.text length];
    if (textLength > 0)
    {
        self.doneBarButton.enabled = YES;
        self.doneBarButton.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.doneBarButton.enabled = NO;
        self.doneBarButton.textLabel.textColor =  [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
    }
    
}
#pragma mark - DatePicker


//Wenn im DatePicker das Datum geändert wird, wird der Text im Datum-Field entsprechend geändert
- (void)changeDate:(UIDatePicker *)sender
{
    self.DateTextField.text = [MMFactory NSStringFromDate:sender.date];
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
    
    [UIView commitAnimations];
}




//Diese Methode wird aufgerufen, wenn das Datum des DatePickers geändert wird
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.DateTextField])
    {
        datePicker = [UIDatePicker new];
        datePicker.datePickerMode= UIDatePickerModeDate;
        
        [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        //Das aktuelle Datum des DatePickers wird im TextFeld angezeigt
        self.DateTextField.inputView = datePicker;
    }
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    
    if ([textField isEqual:self.MarkTextField])
    {
        //Der Done-Button kann nur dann gedrückt werden, wenn im Noten-Feld eine Zahl eingetragen ist
        NSInteger textLength = [textField.text length] - range.length + [string length];
        if (textLength > 0)
        {
            self.doneBarButton.enabled = YES;
            self.doneBarButton.textLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            self.doneBarButton.enabled = NO;
            self.doneBarButton.textLabel.textColor =  [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
            
        }
    }
    // Überprüfe, ob schon ein Punkt gesetzt wurde
    if (([string isEqualToString:@"."] || [string isEqualToString:@","]) && [textField.text containsString:@"."]){
        return NO;
    }
    
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""] || [string isEqualToString:@","] || [string isEqualToString:@"."];
}


#pragma mark - TextField delegates



-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([textField isEqual:self.MarkTextField])
    {
        //Der Done-Button kann nur dann gedrückt werden, wenn im Noten-Feld eine Zahl eingetragen ist
        self.doneBarButton.enabled = NO;
        self.doneBarButton.textLabel.textColor =  [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
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
    double redColor =   41  + (indexPath.row * 116/([MMFactory numberOfRows]-1));
    double greenColor = 135 + (indexPath.row * 94/([MMFactory numberOfRows]-1));
    double blueColor =  241 - (indexPath.row * 110/([MMFactory numberOfRows]-1));
    cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    
    UIColor *color = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    
    if (indexPath.row == 0)
    {
        self.MarkTextField.backgroundColor = color;
        self.MarkTextField.placeholder = @"Mark";
        [cell.contentView addSubview:self.MarkTextField];
        [self.MarkTextField addConstraints];
    }
    
    if (indexPath.row == 1)
    {
        self.WeightingTextField.backgroundColor = color;
        self.WeightingTextField.placeholder = @"Weighting";
        //self.WeightingTextField.text = @"1.0";
        [cell.contentView addSubview:self.WeightingTextField];
        [self.WeightingTextField addConstraints];
    }
    
    if (indexPath.row == 2)
    {
        self.DateTextField.backgroundColor = color;
        self.DateTextField.placeholder = @"Date";
        self.DateTextField.text = [MMFactory NSStringFromDate:[NSDate date]];
        [cell.contentView addSubview:self.DateTextField];
        [self.DateTextField addConstraints];
    }
    
    if (indexPath.row == 3)
    {
        self.NotesTextField.backgroundColor = color;
        self.NotesTextField.placeholder = @"Notes";
        
        [cell.contentView addSubview:self.NotesTextField];
        [self.NotesTextField addConstraints];
        
    }
    
    return cell;
}




//Gibt die Anzahl Rows in Abhängigkeit von der Displaygrösse zurück
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MMFactory numberOfRows]-1;
}


//Gibt die Höhe einer Row in Abhängigkeit von der Displaygrösse zurück
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MMFactory heightForIndexPath:indexPath];
}


#pragma mark - Buttons

//Done pressed
- (void)rightBarButtonItemPressed
{
    
    NSNumber *mark = [NSNumber numberWithDouble:[self.MarkTextField.text doubleValue]];
    NSDate *date;
    if (datePicker.date)
    {
        date = datePicker.date;
    } else {
        if ([self.DateTextField.text isEqualToString:@""]){
            date = [NSDate date];
        } else {
            date = [MMFactory NSDateFromString:self.DateTextField.text];
        }
    }
    
    NSNumber *weighting;
    
    if (self.WeightingTextField.text.length==0 )
    {
        weighting =@1;
    } else
    {
        weighting = @([self.WeightingTextField.text floatValue]);
    }
    if ([self.subject.exam containsObject:self.exam])
    { //Exam wurde bearbeitet
        self.exam.mark = mark;
        self.exam.weighting = weighting;
        self.exam.date = date;
        self.exam.notes = self.NotesTextField.text;
    } else {
        //Neue Exam wurde erstellt
        NSDictionary *dict = @{@"mark": mark,
                               @"weighting":weighting,
                               @"date" : date,
                               @"notes":self.NotesTextField.text
                               };
        
        [[DataStore defaultStore] addExamWithData:dict ToSubject:self.subject];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Cancel Pressed
- (void)leftBarButtonItemPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

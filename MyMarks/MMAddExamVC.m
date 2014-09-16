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

    //Für alle TextFields jeweils: transparenter Background, weisser Rand und Keyboard translucent machen
    self.MarkTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.MarkTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.MarkTextField.layer.borderWidth = 0.8;
    self.MarkTextField.layer.cornerRadius = 0.0f;
    
    self.DateTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.DateTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.DateTextField.layer.borderWidth = 0.8;
    self.DateTextField.layer.cornerRadius = 0.0f;
    
    //Aktueller Tag als Default-Date einsetzen
    self.DateTextField.text = [MMFactory NSStringFromDate:[NSDate date]];
    
    
    self.WeightingTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.WeightingTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.WeightingTextField.layer.borderWidth = 0.8;
    self.WeightingTextField.layer.cornerRadius = 0.0f;
    
    //Notizen-Field wird initialisiert mit einem Border und runden Ecken
    self.NotesTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.NotesTextField.layer.borderWidth = 0.8;
    self.NotesTextField.layer.cornerRadius = 0.0f;
    self.NotesTextField.layer.borderColor =[[UIColor whiteColor] CGColor];
    
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
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    
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

    return YES;
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
    double redColor =   41  + (indexPath.row * 116/9);
    double greenColor = 135 + (indexPath.row * 94/9);
    double blueColor =  241 - (indexPath.row * 110/9);
    cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    
    if (indexPath.row ==1)
    {
        color1 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    }
    
    if (indexPath.row ==2)
    {
        color2 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    }
    
    if (indexPath.row ==3)
    {
        color3 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    }
    
    if (indexPath.row ==4)
    {
        color4 = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    }
    
    self.MarkTextField.backgroundColor = color1;
    self.WeightingTextField.backgroundColor = color2;
    self.DateTextField.backgroundColor =color3;
    self.NotesTextField.backgroundColor = color4;
    
    return cell;
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

//Done pressed
- (void)rightBarButtonItemPressed
{
    
    NSNumber *mark = [NSNumber numberWithDouble:[self.MarkTextField.text doubleValue]];
    NSDate *date;
    if (datePicker.date)
    {
        date = datePicker.date;
    } else {
        date = [MMFactory NSDateFromString:self.DateTextField.text];
    }
    
    NSNumber *weighting;
    if ([self.WeightingTextField.text doubleValue]==0)
    {
        weighting =@1;
    } else
    {
        weighting = [NSNumber numberWithDouble:[self.WeightingTextField.text doubleValue]];
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

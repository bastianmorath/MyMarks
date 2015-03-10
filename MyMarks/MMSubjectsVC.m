//
//  TableViewController.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der TableViewController-Klasse wurde gemischt erstellt

//  Folgende Methoden wurden von Bastian implementiert:
//  -(void)setAverage,  -(double)calculatePlusPoints ,  -(UIBarButtonItem* )getEditIcon, Pragma mark: E-Mail

//  Folgende Methoden wurden von Florian implementiert:
//  -(NSMutableArray *)getSubjectArray

//  Die restlichen Methoden wurden gemeinsam implementiert


#import "MMSubjectsVC.h"


@implementation MMSubjectsVC

const char MyConstantKey;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.semester = [[DataStore defaultStore] currentSemester];
    [self updateSubjectArray];
    [self.navigationViewButton update];
    [self.tableView reloadData];

}


-(void)viewDidLoad
{
    [super viewDidLoad];
    //Navigation-Title auf weisse Schrift setzen
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    //Barbutton-Items auf weisse Schrift setzen
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
    //Rechter Button erstellen
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];
  
    //Linkes Logo setzen
    self.navigationItem.leftBarButtonItem=[MMFactory appIconItem];

    //Scrollen im TabelView verhindern
    [[self tableView]setBounces:NO];
    
    //Schwarzer Strich am unteren Ende der Navigationbar entfernen
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];

    //"Zurück-Button"-Titel des Navigation-Controllers ändern
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    //Background auf eine Grundfarbe setzen, damit zum Beispiel beim Zeilen-Verschieben kein weisser Hintergrund zu sehen ist
    self.view.backgroundColor = [MMFactory blueColor];
    
    

    //Navigation Button initlialisieren
    self.navigationViewButton = [[MMNavigationViewButton alloc]initWithTarget:self];;
    self.navigationItem.titleView = self.navigationViewButton;
    


    //**Google Analytics**//
    [MMFactory initGoogleAnalyticsForClass:self];
       
    
    //Long Tap Gesture hinzufügen. Wird länger auf eine Cell gedrückt, kann sie editiert werden
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.6;
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
}


#pragma mark - GetterMethoden

//Diese Methode gibt den Array mit den Fächer zurück


-(void)updateSubjectArray;
{
    self.subjectArray =  [[DataStore defaultStore] subjectArray];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Gibt die Anzahl Section zurück
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows=0;
    //Es hat immer so viele Cells wie der SubjectArray Elemente hat, aber mindestens 10, damit der ganze Bildschirm ausgefüllt ist
    if ([self.subjectArray count]<10)
    {
        numberOfRows = 10;
    } else
    {
        numberOfRows = [self.subjectArray count];
    }
    return numberOfRows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Höhe wird so gesetzt, dass gerade 10 Rows Platz haben
    return ([[UIScreen mainScreen] bounds].size.height-64)/10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    


    
        //Je nach dem, ob weniger/gleich oder mehr als 10 Fächer eingetragen wurden(bei über 10 verlassen die untersten Zellen den Screen), wird der Farbverlauf der Zellen anderst konfiguriert
    if ([self.subjectArray count]<=10)
    {
        double redColor =   41  + (indexPath.row * 116/9);
        double greenColor = 135 + (indexPath.row * 94/9);
        double blueColor =  241 - (indexPath.row * 110/9);

        cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    } else
    {
        double redColor =   41  + (indexPath.row * 116/([self.subjectArray count]-1));
        double greenColor = 135 + (indexPath.row * 94/([self.subjectArray count]-1));
        double blueColor =  241 - (indexPath.row * 110/([self.subjectArray count]-1));
        cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    }

    //Die Cells, in welche ein Fach eingetragen werden soll, werden mit Fachnamen und Durchschnitt konfiguriert
    if ([self.subjectArray count]>indexPath.row)
    {
        MMSubject *subject = [self.subjectArray objectAtIndex:indexPath.row];
        //Die Labels der Cells werden konfiguriert und der Hintergrund transparent gemacht
        cell.textLabel.text = subject.name;

        [cell.detailTextLabel setFrame:CGRectMake(254, 15, 50, 20.5)];
        cell.detailTextLabel.text = subject.average>0 ? [NSString stringWithFormat:@"%.2f", subject.average] : [NSString stringWithFormat:@"0.0"];
    } else //Wenn kein Fach eingetragen wurde
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text=@"";
    }
    
    return cell;
}



#pragma mark - Table View Actions

//Diese Methode wird aufgerufen, wenn eine Cell gedrückt wird
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.subjectArray count]>=indexPath.row+1)
    {
        //Segue wird gestartet
    [self performSegueWithIdentifier:@"detailsegue" sender:indexPath];
    }
}



#pragma mark - Edit Modus

//Diese Methode wird aufgerufen, wenn sich der TableView im Editing-Modus befindet
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Entfernen des zu löschendem Elements aus dem Datenspeicher
        [[DataStore defaultStore] deleteObject:[self.subjectArray objectAtIndex:indexPath.row]];
        ;
        //Position müssen neu gesetzt werden
        [self updateSubjectArray];
        [self.navigationViewButton updateText];

        if ([self.subjectArray count]==0)
        {
            [self donePressed];
        } else
        {
            [self updatePositions];
        }
        [self.tableView reloadData];

    }
}

-(void)updatePositions{
    int counter=0;
    
    for (MMSubject *subject in self.subjectArray)
    {
        subject.position= @(counter);
        counter++;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >=[self.subjectArray count])
    {
        return NO;
    }
    return YES;
}

//Diese Methode wird aufgerufen, wenn eine Zelle verschoben wird
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceIndex = [sourceIndexPath row];
    NSUInteger destinationIndex = [destinationIndexPath row];
    
    
    //Die Verschiebung der Zellen wird auch im Datenspeicher  geändert
    
    [self insertSubjectFromPosition:sourceIndex ToPosition:destinationIndex];
    //Der Table View wird nach 0.3 Sekunden neu geladen, damit es dynamischer aussieht
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(breakBeforeReload) userInfo:nil repeats:NO];
    
    
    
}

-(void)insertSubjectFromPosition:(int)sourceIndex ToPosition:(int)destinationIndex{
    //Temporärer Array erstellen, um die Veschiebung einfacher zu machen. Am Schluss werden die 'Positions' wieder updated
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.subjectArray];
    
    MMSubject *tempSubject = [array objectAtIndex:sourceIndex];
    [array removeObjectAtIndex:sourceIndex];
    [array insertObject:tempSubject atIndex:destinationIndex];
    
    //Positions updaten
    for (int i =0; i<[array count]; i++) {
        MMSubject *subject = [array objectAtIndex:i];
        subject.position= @(i);
    }
    [self updateSubjectArray];
}


-(void)breakBeforeReload{
    [self.tableView reloadData];
}

//Diese Methode ist dafür zuständig, dass die zu verschiebende Row nicht über den Facharray hinaus verschoben wird, sondern höchstens daran angehängt wird
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    
    if (proposedDestinationIndexPath.row >=[self.subjectArray count])
    {
        
        NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForRow:[self.subjectArray count]-1 inSection:0];
            return lastCellIndexPath;
    } else
    {
        
        return proposedDestinationIndexPath;
    }
}

//Verhindern, dass durch Swipen über die Zeile Zellen gelöscht werden können
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.subjectArray count])
    {
        return UITableViewCellEditingStyleNone;
    }
    if (self.tableView.isEditing )
    {
        return UITableViewCellEditingStyleDelete;
    } else
    {
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![self.tableView isEditing];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //AlertView, um Namen des Faches zu ändern
        UIAlertView *alert;
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Change name", nil)
                                         message:NSLocalizedString(@"Enter the new name of the Subject", nil)
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                               otherButtonTitles:@"Done", nil];
        [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
        [alert show];
        
        //Übergebe dem AlertView das Fach
        objc_setAssociatedObject(alert, MyConstantKey, [self.subjectArray objectAtIndex:indexPath.row], OBJC_ASSOCIATION_RETAIN);
    }
}

#pragma mark - Buttons

- (void)editPressed
{
    [self.tableView setEditing:YES animated:YES];
    //Plus-Button verschwindet, wenn man am Editieren ist
    self.navigationItem.rightBarButtonItem.enabled=YES;
    
    //Donebutton erstellen, der während dem Editieren angezeigt wird
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    //Editbutton wird zu einem DoneButton animiert geändert
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
}


-(void)donePressed
{
    //Edit-Modus wird beendet
    [self.tableView setEditing:NO animated:YES];
    
    //Pencil-Button wird wieder angezeigt
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];

}

-(void)openPreferences{
    [self performSegueWithIdentifier:@"openPreferences" sender:nil];
}

- (void)navigationButtonPressed{
    [self.navigationViewButton changeType];
}


#pragma mark - Navigation

//Vor dem Aufruf eines neuen Controllers werden Vorbereitungen gemacht
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Wenn auf eine Cell gedrückt wird, wird der Segue mit dem Identifier "detailSegue" aufgerufen
    if ([segue.identifier isEqualToString:@"detailsegue"])
    {
        MMExamsVC *dvc = [segue destinationViewController];
    
        //Der indexPath wird aus der Methode tableView:didSelectRowAtIndexPath als Sender übergeben
        NSIndexPath *indexPath = sender;
        
        //Der String des Faches wird als Titel in der NavigationBar angezeigt
        MMSubject *subject = [self.subjectArray objectAtIndex:indexPath.row];
        dvc.title = [NSString stringWithFormat:@"%@",subject.name];
        
        //Das angeklickte Fach wird im DetailViewController unter "Subject" gespeichert
        dvc.subject = subject;
    }
 }



#pragma mark - AlertView

//Hinzufügen einer Prüfung
-(void)addSubject
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add subject", nil)
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                        otherButtonTitles:NSLocalizedString(@"Add", nil), nil];
    [alert setAlertViewStyle: UIAlertViewStyleLoginAndPasswordInput];
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Name"];
    [[alert textFieldAtIndex:1] setPlaceholder:@"Gewichtung: 0/1"];
    [alert show];
}


//Methode, die aufgerufen wird, wenn ein Button des AlertViews gedrückt wird
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //Diese if-Schlaufe wird durchlaufen, wenn der AlertView des "Prüfung hinzufügen" aufgerufen wird
        if ([alertView.title isEqualToString:NSLocalizedString(@"Add subject", nil)])
        {
            if (![[alertView textFieldAtIndex:0].text isEqualToString:@""])
            {
                //Ein neues Fach wird erstellt und im DataHandler hinzugefügt. Der Text des AlertViews wird unter dem Fachnamen des Faches gespeichert.
                NSString *name= [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text].capitalizedString;
                NSNumber *weighting = [NSNumber numberWithFloat:[[alertView textFieldAtIndex:1].text floatValue]];
                if ([[alertView textFieldAtIndex:1].text isEqualToString:@""])
                {
                    [[DataStore defaultStore]createSubjectWithName:name AndWeighting:@1 AndSemester:self.semester];
                } else if ( ([weighting isEqualToNumber:@1]) || [weighting isEqualToNumber:@0])
                {
                    [[DataStore defaultStore]createSubjectWithName:name AndWeighting:weighting AndSemester:self.semester];
                } else {
                    // Gewichtung wurde falsch eingegeben
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", nil)
                                                                  message:NSLocalizedString(@"Weighting Error", nil)
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                        otherButtonTitles:@"Ok", nil];
                    [alert setAlertViewStyle: UIAlertViewStyleDefault];
                    [alert show];
                }
                
                [self updateSubjectArray];
                [self.tableView reloadData];
            }
        }
        // Alert-View with Title-Error: When User Accepted Error
        if ([alertView.title isEqualToString:NSLocalizedString(@"Error", nil)])
        {
            [self addSubject];
        }
        
        
        //Änderung des Subjectsnamens bei längerem Drücken einer Cell
        if ([alertView.title isEqualToString:    NSLocalizedString(@"Change name", nil)
             ] && buttonIndex ==1)
        {
            MMSubject *subject = objc_getAssociatedObject(alertView, MyConstantKey);
            NSString *newSubjectName= [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text].capitalizedString;
          
            subject.name =newSubjectName;
            [self updateSubjectArray];
            [self.tableView reloadData];
        }


    }
}

//Wenn ein Semester-Name geändert wird, dann kann man ihn nur ändern, wenn etwas im TextField eingegeben wurde!
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"Add subject", nil)])
    {
        //Prüfe, dass im Gewichtung-TextField nur Ziffern vorkommen + name-TextField nicht leer ist
        if([[[alertView textFieldAtIndex:0] text] length] >= 1  && [[[alertView textFieldAtIndex:1] text]  rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound )
        {
            return YES;
        }
        else
        {
            return NO;
        }

    } else {
        return YES;
    }
    
    
}

#pragma  mark - Action Sheet

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Add new subject", nil), NSLocalizedString(@"Edit subjects", nil), NSLocalizedString(@"Export marks", nil), NSLocalizedString(@"Preferences", nil), nil];
                                  
    [actionSheet showInView:self.view];
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
    {
        [self addSubject];
    }
    
    if(buttonIndex == 1)
    {
        [self editPressed];
    }
    
    if(buttonIndex == 2)
    {
        [self exportMarks];
    }
    
    if(buttonIndex == 3)
    {
        [self openPreferences];
    }
}


# pragma mark - Export marks

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
    [writeString appendString:@"MyMarks \r\r"];
    
    //Note, Gewichtung, Datum und Notizen einer Prüfung werden dem NSMutableString angehängt
    for (MMSemester *semester in [[DataStore defaultStore]semesterArray])
    {
        [writeString appendString:@"\r\r"];
        [writeString appendString:[NSString stringWithFormat:@"%@: Pluspunkte: %0.2f  Durchschnitt: %0.2f \n ",semester.name, semester.plusPoints, semester.average]];
        
        for (MMSubject *subject in semester.subject)
        {
            [writeString appendString:[NSString stringWithFormat:@"\r%@\r ",subject.name]];
            
            for (MMExam *eachExam in [subject.exam allObjects])
            {
                [writeString appendString:[NSString stringWithFormat:
                                           @"\tNote: \t%0.2f       Gewichtung: \t%0.2f       Datum:\t %@       Notizen:  \t%@ \r",
                                           eachExam.mark.floatValue, eachExam.weighting.floatValue, [MMFactory NSStringFromDate:eachExam.date], eachExam.notes]];
            }
            [writeString appendString:@"\n"];
        }
        [writeString appendString:@"\r\r"];
    }
    
    
    NSFileHandle *handle;
    //Sagt, wo das File gelesen werden soll
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    //Stellt den Cursor ans Ende des Files
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Ein Controller für das Mail-Programm wird erstellt und aufgerufen
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [mailer.view setTintColor:[UIColor whiteColor]];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"MyMarks"];
    [mailer addAttachmentData:[NSData dataWithContentsOfFile:[self dataFilePath] ]
                     mimeType:@"text/csv"
                     fileName:@"MyMarks.csv"];
    [self presentViewController:mailer animated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end


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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
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
    //self.navigationItem.rightBarButtonItem= [MMFactory editIconItemForClass:self];
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
    self.view.backgroundColor = [UIColor colorWithRed:61/255.0f green:132/255.0f blue:238/255.0f alpha:1];
    
    //Navigation Button initlialisieren
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"calcType"] isEqualToNumber:@0]) {
        self.navigationViewButton = [[MMNavigationViewButton alloc]initWithType:BTAverage AndTarget:self];
    } else {
        self.navigationViewButton = [[MMNavigationViewButton alloc]initWithType:BTPluspoints AndTarget:self];

    }
    self.navigationItem.titleView = self.navigationViewButton;
    
    //Semester setzen
    NSString *semesterName = [[NSUserDefaults standardUserDefaults]objectForKey:@"semester"];
    for (Semester *semester in [[DataStore defaultStore]getSemesters]) {
        if ([semester.name isEqualToString:semesterName]) {
            self.semester = semester;
        }
    }
    

    //**Google Analytics**//

    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"MMSubjectsVC"];

    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


#pragma mark - GetterMethoden

//Diese Methode gibt den Array mit den Fächer zurück


-(void)updateSubjectArray;
{
    self.subjectArray =  [[DataStore defaultStore] getSubjects];
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
    
    //Farbe wird bestimmt, welche beim Drücken einer Zelle angezeigt wird 
    UIView *selectetView = [[UIView alloc]init];
    selectetView.backgroundColor = [UIColor colorWithRed:30/255.0f green:115/255.0f blue:238/255.0f alpha:1];
    cell.selectedBackgroundView = selectetView;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    
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

    //Die Cells, in welche ein Fach eingetragen werden soll, werden mit Fachnamen und Durchschnitt kofiguriert
    if ([self.subjectArray count]>indexPath.row)
    {
        Subject *subject = [self.subjectArray objectAtIndex:indexPath.row];

        //Die Labels der Cells werden konfiguriert und der Hintergrund transparent gemacht
        cell.textLabel.text = subject.name;

        [cell.detailTextLabel setFrame:CGRectMake(280, 15, 24, 20.5)];
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
    if ([self.subjectArray count]-1>=indexPath.row)
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

        [self updatePositions];
        [self.navigationViewButton updateText];
       
        [self.tableView reloadData];
    }
}

-(void)updatePositions{
    int counter=0;
    
    for (Subject *subject in self.subjectArray) {
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
    
    [self changePosition:sourceIndex WithPosition:destinationIndex];
    
    //Der Table View wird nach 0.3 Sekunden neu geladen, damit es dynamischer aussieht
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(breakBeforeReload) userInfo:nil repeats:NO];
    
    
    
}

-(void)changePosition:(int)sourceIndex WithPosition:(int)destinationIndex{
    for (Subject *sourceSubject in self.subjectArray) {
        if ([sourceSubject.position intValue] == sourceIndex) {
            for (Subject *destinationSubject in self.subjectArray) {
                if ([destinationSubject.position intValue] == destinationIndex) {
                    //Change positions
                    sourceSubject.position = [NSNumber numberWithInt:destinationIndex];
                    destinationSubject.position = [NSNumber numberWithInt:sourceIndex];
                    
                    //SubjectArray updaten
                    [self updateSubjectArray];
                    return;
                }
            }
        }
    }
    
    //SubjectArrays updaten
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
        Subject *subject = [self.subjectArray objectAtIndex:indexPath.row];
        dvc.title = [NSString stringWithFormat:@"%@",subject.name];
        
        //Das angeklickte Fach wird im DetailViewController unter "Subject" gespeichert
        dvc.subject = subject;
    }
 }



#pragma mark - E-Mail

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
    [writeString appendString:@"MyMarks \n \n"];
    
    //Note, gewichtung, Datum und Notizen einer Prüfung werden dem NSMutableString angehängt
    for (int i=0; i<[self.subjectArray count]; i++)
    {
        Subject *subject = [self.subjectArray objectAtIndex:i];
        [writeString appendString:[NSString stringWithFormat:@"\n\n%@\n ",subject.name]];
        
        for (Exam *eachExam in [subject.exam allObjects])
        {
            [writeString appendString:[NSString stringWithFormat:
                                       @"Note: \t%0.2f       Gewichtung: \t%0.2f       Datum:\t %@       Notizen:  \t%@ \n\n",
                                       eachExam.mark.floatValue, eachExam.weighting.floatValue, eachExam.date, eachExam.notes]];
        }
        [writeString appendString:@"\t\n\n"];
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
                
                [[DataStore defaultStore]createSubjectWithName:name AndWeighting:[[alertView textFieldAtIndex:1].text floatValue]AndSemester:self.semester];
                
                [self updateSubjectArray];
                [self.tableView reloadData];
            }
        }
    }
}


#pragma  mark - Action Sheet

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Add new subject", nil), NSLocalizedString(@"Edit subjects", nil), NSLocalizedString(@"Export marks", nil), NSLocalizedString(@"Preferences", nil), nil];
                                  
    [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

@end


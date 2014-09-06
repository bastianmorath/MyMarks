//
//  DetailViewController.m
//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der DetailViewController-Klasse wurde gemischt erstellt

//  Folgende Methoden wurden von Bastian implementiert:
//  -(double)getAvarage, -(void)addExamViewController:(AddExamController *)controller didFinishAddingPruefung:(Exam *)exam, -(void)addExamViewControllerDidCancel:(AddExamController *)controller

//  Folgende Methoden wurden von Florian implementiert
//  -(NSMutableArray *)getSubjectArray,

//  Die restlichen Methoden wurden gemeinsam implementiert


#import "DetailViewController.h"


@implementation DetailViewController


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
    [super viewWillAppear:animated];
    
    
    [self setEditButton];
    
    [self.tableView reloadData];
    
}


-(void)viewDidLoad
{
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    //Editbutton erstellen, der angezeigt wird
    [self.navigationItem setRightBarButtonItem:[MMFactory editIconItemForClass:self] animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.titleView = [MMFactory getNavigationViewForString:self.subject.name];
}



#pragma mark- SetterMethoden

-(void)setEditButton
{
    if (self.subject.average==0)
    { // Wenn der Durchschnitt des Faches gleich 0 ist (Keine Prüfungen wurden hinzugefügt), ist der Edit-Button nicht anklickbar
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


#pragma mark- Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Gibt die Anzahl der Sections zurück
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Gibt die Anzahl der Zeilen für die Sections zurück
    if (section ==0)
    {
        return 1;
    } else
    {
        return [[self.subject.exam allObjects] count]+1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 90;
    } else
    {
        return 46;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Section: 0
    if (indexPath.section ==0) {
        static NSString *CellIdentifier = @"averageCell";
        UITableViewCell *averageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        //Hintergrund und Schriftfarbe der Cell wird bestimmt
        averageCell.backgroundColor = [UIColor colorWithRed:30/255.0f green:115/255.0f blue:238/255.0f alpha:1];
        UILabel *label = (UILabel *)[averageCell viewWithTag:1];
        
        
        
        
        if ([[self.subject.exam allObjects] count]!=0 )
        {
            //Im Label wird der Durchschnitt angezeigt
            label.text = [NSString stringWithFormat:@"%.2f", self.subject.average];
        }else
            //Wenn keine Prüfung hinzugefügt wurde, wird der Durchscnitt 0.0 angezeigt
        {
            averageCell.textLabel.text = [NSString stringWithFormat:@"0.0"];
        }
        
        return averageCell;
        
        
        //Section:1
    } else {
        
        
        //Die if-Schlaufe wird auf die Cells ausgeführt, wo mindestens eine Prüfung erstellt wurde UND wo die Row  nicht dem indexpath.row entspricht (Das wäre gerade die Cell, welche für das Hinzufügen einer neuen Prüfung zuständig ist)
        
        
        
        if ([[self.subject.exam allObjects]count]!=0 && [[self.subject.exam allObjects] count]!=indexPath.row )
        {
            static NSString *CellIdentifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            //Hintergrundverlauf der Zellen wird bestimmt. Verlauf von Blau nach Grün
            double redColor =   35  + (indexPath.row * 136/([[self.subject.exam allObjects]count]+1));
            double greenColor = 129 + (indexPath.row * 114/([[self.subject.exam allObjects] count]+1));
            double blueColor =  238 - (indexPath.row * 130/([[self.subject.exam allObjects] count]+1));
            cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
            
            
            //Farbe wird bestimmt, welche beim Drücken einer Zelle angezeigt wird
            UIView *selectetView = [[UIView alloc]init];
            selectetView.backgroundColor = [UIColor colorWithRed:30/255.0f green:115/255.0f blue:238/255.0f alpha:1];
            cell.selectedBackgroundView = selectetView;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            Exam *exam = [[self.subject.exam allObjects] objectAtIndex:indexPath.row];
            
            [self configureTextForCell:cell withExam:exam];
            //Wenn noch keine Prüfung hinzugefügt wurde
            return cell;
            
        } else
        {
            static NSString *CellIdentifier = @"newExamCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            UILabel *label = (UILabel *)[cell viewWithTag:1];

            cell.accessoryType = UITableViewCellAccessoryNone;
            label.text = @"Neue Prüfung hinzufügen";
            cell.backgroundColor =[UIColor colorWithRed:130/255.0f green:200/255.0f blue:150/255.0f alpha:1];
            return cell;
            
        }
        
    }
}


//Diese Methode konfiguriert eine Zelle mit Note und Datum der Prüfung
-(void)configureTextForCell:(UITableViewCell *)cell withExam:(Exam *)exam
{
    cell.textLabel.text = [NSString stringWithFormat:@"%@", exam.mark ];
    
    cell.detailTextLabel.text = [MMFactory NSStringFromDate:exam.date];
}





//Diese Methode setzt die Titel der Sections auf weisse Schrift
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,3000,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica Light" size:17];
    tempLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    if (section ==0)
    {
        tempLabel.text=@"Durchschnitt";
    } else
    {
        tempLabel.text=@"Noten";
    }
    
    [tempView addSubview:tempLabel];
    return tempView;
}

#pragma mark- addExamController





#pragma mark- Table View Actions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"addExamSegue" sender:indexPath];
}


#pragma mark- EditModus

//Diese Methode wird aufgerufen, wenn sich der TableView im Editing-Modus befindet
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([[self.subject.exam allObjects]count]!=0) {
            
            if (indexPath.section!=0 & indexPath.row <= [[self.subject.exam allObjects] count] )
            {
                //Entfernen des zu löschendem Elements aus dem Datenspeicher
                NSLog(@"Exams :%@", [[self.subject.exam allObjects]objectAtIndex:indexPath.row]);
                [[DataStore defaultStore] deleteObject:[[self.subject.exam allObjects]objectAtIndex:indexPath.row]];
                [self.tableView reloadData];
                
                //Löschen der Zeile aus dem TableView
                //                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self setEditButton];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


//Die Reihenfolge der Fächer kann im Edit-Mode geändert werden
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceIndex = [sourceIndexPath row];
    NSUInteger destinationIndex = [destinationIndexPath row];
    
    if (sourceIndex != destinationIndex)
    {
        /////// [self.getSubject.examArray exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
    }
}

//Diese methode bestimmt, welche Zellen man verschieben kann
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Durchschnitt-Cell, erste Cell (wenn noch keine Prüfung erstellt wurde) und die letzte Cell sollen nicht editierbar sein
    if (indexPath.section==0 ||  indexPath.row >= [[self.subject.exam allObjects] count] || [[self.subject.exam allObjects] count]==0 )
    {
        return NO;
    }
    return YES;
}



#pragma mark- Buttons

- (IBAction)editPressed:(id)sender
{
    //Der Table View wird in den Edit-Modus versetzt
    [self.tableView setEditing:YES animated:YES];
    
    //Donebutton erstellen, der während dem Editieren angezeigt wird
    UIBarButtonItem *doneButton =[[ATBarButtonItem alloc]initWithText:@"Done" target:self Position:PTRight];
    
    //Editbutton wird zu einem DoneButton animiert geändert
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
}

-(void)rightBarButtonItemPressed
{
    //Der Edit-Modus des Table Views wird beendet
    [self.tableView setEditing:NO animated:YES];
    
    //Editbutton erstellen, der während dem Nicht-Editieren angezeigt wird
    self.navigationItem.rightBarButtonItem= [MMFactory editIconItemForClass:self];
}



#pragma mark- Navigation

//Vor dem Aufruf eines neuen Controllers werden Vorbereitungen gemacht
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Wenn auf eine Cell gedrückt wird, wird der Segue mit dem Identifier "addNoteSegue" aufgerufen
    if ([segue.identifier isEqualToString:@"addExamSegue"])
    {
        UINavigationController *tableViewController = segue.destinationViewController;
        AddExamController *controller =(AddExamController *)tableViewController.topViewController;
        
        //Der indexPath wird aus der Methode tableView:didSelectRowAtIndexPath als Sender übergeben
        NSIndexPath *indexPath = sender;
        
        controller.subject=self.subject;
        
        if (indexPath.row != [[self.subject.exam allObjects] count]) //user fügt eine neue Prüfung hinzu
        {
            controller.exam = [[self.subject.exam allObjects]objectAtIndex:indexPath.row];
        }
    }
}


@end

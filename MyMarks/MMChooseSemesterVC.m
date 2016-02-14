//
//  MMChooseSemester.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMChooseSemesterVC.h"

@interface MMChooseSemesterVC ()
{
    
    NSIndexPath *currentIndexPathToDelete;
    const void* MyConstantKey;
    
}

@end

@implementation MMChooseSemesterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Rechter Button erstellen
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAlertViewToAddSemester)];
    
    self.navigationItem.leftBarButtonItem = [MMFactory backBarButtonItemForClass:self];
    
    //Background setzen
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    [self.tableView setBackgroundView:backgroundView];
    
    //Scrollen im TabelView verhindern
    [[self tableView]setBounces:NO];
    
    
    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Choose semester", nil)];
    
    
    semesterArray = [[NSArray alloc]init];
    [self updateSemesterArray];
    
    
    
    //Wenn noch kein Semester hinzugefügt wurde, öffne direkt den AlertView
    
    if ([semesterArray count] == 0)
    {
        [self showAlertViewToAddSemester];
    }
    
    
    //Long Tap Gesture hinzufügen. Wird länger auf eine Cell gedrückt, kann sie editiert werden
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.7; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    
}


-(void)updateSemesterArray{
    semesterArray = [[DataStore defaultStore]semesterArray];
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return semesterArray.count >[MMFactory numberOfRows] ? semesterArray.count : [MMFactory numberOfRows];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MMFactory heightOfRow];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Cell konfigurieren
    if (indexPath.row<semesterArray.count)
    {
        MMSemester *semester =[semesterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = semester.name;
        
        //Wenn nur ein Semester hinzugefügt wurde, dann klicke es automatisch an
        if ([semesterArray count]==1)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else
        {
            if (    [[[NSUserDefaults standardUserDefaults] objectForKey:@"semester"]isEqualToString:semester.name])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else {
        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    //Farbverlauf bestimmen
    //Je nach dem, ob weniger/gleich oder mehr als 10 Fächer eingetragen wurden(bei über 10 verlassen die untersten Zellen den Screen), wird der Farbverlauf der Zellen anderst konfiguriert
    if ([semesterArray count]<=[MMFactory numberOfRows])
    {
        double redColor =   41  + (indexPath.row * 116/([MMFactory numberOfRows]-1));
        double greenColor = 135 + (indexPath.row * 94/([MMFactory numberOfRows]-1));
        double blueColor =  241 - (indexPath.row * 110/([MMFactory numberOfRows]-1));
        
        cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    } else
    {
        double redColor =   41  + (indexPath.row * 116/(semesterArray.count-1));
        double greenColor = 135 + (indexPath.row * 94/(semesterArray.count-1));
        double blueColor =  241 - (indexPath.row * 110/(semesterArray.count-1));
        cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < semesterArray.count){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *semesterName = cell.textLabel.text;
        
        [[NSUserDefaults standardUserDefaults] setObject:semesterName forKey:@"semester"];
        [self.tableView reloadData];
    }
}

#pragma mark - TableView Editing
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    if (indexPath.row<semesterArray.count) {
        return YES;
    } else{
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Bestätigung der Löschung mit AlertView
        [self showConfirmationAlertView];
        
        currentIndexPathToDelete = indexPath;
    }
}


-(void)deleteSemesterAtIndexPath:(NSIndexPath*)indexPath
{
    
    //Entfernen des zu löschendem Elements aus dem Datenspeicher
    
    //Wenn das letzte Semester gelöscht wird, wird der AlertView angezeigt
    if ([semesterArray count] ==1)
    {
        
        [[DataStore defaultStore] deleteObject:[semesterArray objectAtIndex:indexPath.row]];
        
        [self updateSemesterArray];
        [self showAlertViewToAddSemester];
        
        //Wenn gerade das Semester gelöscht wird, das ausgewählt ist, dann wird das erste Semester als das Neue verwendet
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"semester"] isEqualToString:((MMSemester *)[semesterArray objectAtIndex:indexPath.row]).name])
    {
        
        [[DataStore defaultStore] deleteObject:[semesterArray objectAtIndex:indexPath.row]];
        
        [self updateSemesterArray];
        [[NSUserDefaults standardUserDefaults]setObject:((MMSemester *)[semesterArray objectAtIndex:0]).name forKey:@"semester"];
    } else {
        //Sonst wird einfach das Semester aus dem DataStore gelöscht
        [[DataStore defaultStore] deleteObject:[semesterArray objectAtIndex:indexPath.row]];
    }
    
    
    [self updateSemesterArray];
    [self.tableView reloadData];
    
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



#pragma mark - AlertView

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //AlertView, um Namen des Semesters zu ändern
        UIAlertView *alert;
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Change name", nil)
                                         message:NSLocalizedString(@"Enter the new name of the semester", nil)
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                               otherButtonTitles:NSLocalizedString(@"Done",nil)   , nil];
        [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
        [alert show];
        
        //Übergebe dem AlertView das Semester
        objc_setAssociatedObject(alert, MyConstantKey, [semesterArray objectAtIndex:indexPath.row], OBJC_ASSOCIATION_RETAIN);
        
    }
    
}

-(void)showConfirmationAlertView{
    UIAlertView *alert;
    alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Confirmation", nil)
                                     message:NSLocalizedString(@"confirmationMessage", nil)
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                           otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    [alert setAlertViewStyle: UIAlertViewStyleDefault];
    [alert show];
}


//Hinzufügen einer Prüfung
-(void)showAlertViewToAddSemester
{
    UIAlertView *alert;
    //Wenn kein Semester vorhanden ist, kann der User nicht abbrechen
    if ([semesterArray count]!=0)
    {
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add semester", nil)
                                         message:nil
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                               otherButtonTitles:NSLocalizedString(@"Done", nil), nil];
    } else
    {
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add semester", nil)
                                         message:nil
                                        delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:NSLocalizedString(@"Done", nil), nil];
    }
    
    
    [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"Name",nil)];
    [alert show];
}


//Wenn ein Semester-Name geändert wird, dann kann man ihn nur ändern, wenn etwas im TextField eingegeben wurde!
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    if([[[alertView textFieldAtIndex:0] text] length] >= 1 || [alertView.title isEqualToString:NSLocalizedString(@"Confirmation", nil)] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//Methode, die aufgerufen wird, wenn ein Button des AlertViews gedrückt wird
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.title isEqualToString:NSLocalizedString(@"Add semester", nil)])
    {
        if (buttonIndex==1 || [semesterArray count]==0)
        {
            if (![[alertView textFieldAtIndex:0].text isEqualToString:@""])
            {
                //Ein neues Fach wird erstellt und im DataHandler hinzugefügt. Der Text des AlertViews wird unter dem Fachnamen des Faches gespeichert.
                NSString *name= [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text].capitalizedString;
                
                [[DataStore defaultStore] createSemestertWithName:name];
                [self updateSemesterArray];
                [self.tableView reloadData];
            }
        }
    }
    
    if ([alertView.title isEqualToString:NSLocalizedString(@"Confirmation", nil)])
    {
        if  (buttonIndex == 0)
        {

                // User will Semester nicht löschen
            
                [self setEditing:NO animated:YES];
        } else {
            [self deleteSemesterAtIndexPath:currentIndexPathToDelete];

        }
        
    }
    
    
    
    
    if ([alertView.title isEqualToString:    NSLocalizedString(@"Change name", nil)
         ] && buttonIndex ==1)
    {
        MMSemester *semester = objc_getAssociatedObject(alertView, MyConstantKey);
        NSString *newSemesterName= [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text].capitalizedString;
        if ([semester.name isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"semester"]])
        {
            [[NSUserDefaults standardUserDefaults]setObject:newSemesterName forKey:@"semester"];
        }
        
        semester.name =newSemesterName;
        [self updateSemesterArray];
        [self.tableView reloadData];
        
    }
    
}



@end

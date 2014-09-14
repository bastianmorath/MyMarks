//
//  MMChooseSemester.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMChooseSemesterVC.h"

@interface MMChooseSemesterVC (){
    
    NSIndexPath *currentIndexPathToDelete;
    const char MyConstantKey;

}

@end

@implementation MMChooseSemesterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    
    //Rechter Button erstellen
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAlertViewToAddSemester)];
    
    self.navigationItem.leftBarButtonItem = [MMFactory backBarButtonItemForClass:self];
    
    //Background setzen
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    
    //Scrollen im TabelView verhindern
    [[self tableView]setBounces:NO];
    
    
    self.navigationItem.titleView = [MMFactory getNavigationViewForString:NSLocalizedString(@"Choose semester", nil)];
    
    
    semesterArray = [[NSArray alloc]init];
    [self updateSemesterArray];
    
    
    
    //Wenn noch kein Semester hinzugefügt wurde, öfne direkt den AlertView
    
    if ([semesterArray count] == 0) {
        [self showAlertViewToAddSemester];
    }
    //**Google Analytics**//
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"MMChooseSemesterVC"];
    
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //Long Tap Gesture hinzufügen. Wird länger auf eine Cell gedrückt, kann sie editiert werden
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    
}


-(void)updateSemesterArray{
    semesterArray = [[DataStore defaultStore]getSemesters];
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return semesterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    
    Semester *semester =[semesterArray objectAtIndex:indexPath.row];
    cell.textLabel.text = semester.name;
    
    //Wenn nur ein Semester hinzugefügt wurde, dann klicke es automatisch an
    if ([semesterArray count]==1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        if (    [[[NSUserDefaults standardUserDefaults] objectForKey:@"semester"]isEqualToString:semester.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *semesterName = cell.textLabel.text;

    [[NSUserDefaults standardUserDefaults] setObject:semesterName forKey:@"semester"];
    [self.tableView reloadData];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

-(void)deleteSemesterAtIndexPath:(NSIndexPath*)indexPath {
    
    //Entfernen des zu löschendem Elements aus dem Datenspeicher
    
    //Wenn das letzte Semester gelöscht wird, wird der AlertView angezeigt
    if ([semesterArray count] ==1) {
        
        [[DataStore defaultStore] deleteObject:[semesterArray objectAtIndex:indexPath.row]];
        
        [self updateSemesterArray];
        [self showAlertViewToAddSemester];
        
        //Wenn gerade das Semester gelöscht wird, das ausgewählt ist, dann wird das erste Semester als das Neue verwendet
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"semester"] isEqualToString:((Semester *)[semesterArray objectAtIndex:indexPath.row]).name]){
        
        [[DataStore defaultStore] deleteObject:[semesterArray objectAtIndex:indexPath.row]];
        
        [self updateSemesterArray];
        [[NSUserDefaults standardUserDefaults]setObject:((Semester *)[semesterArray objectAtIndex:0]).name forKey:@"semester"];
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
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //AlertView, um Namen des Semesters zu ändern
        UIAlertView *alert;
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Change name", nil)
                                         message:NSLocalizedString(@"Enter the new name of the semester", nil)
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                               otherButtonTitles:@"Done", nil];
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
                           otherButtonTitles:@"Okey", nil];
    [alert setAlertViewStyle: UIAlertViewStyleDefault];
    [alert show];
}

//Hinzufügen einer Prüfung
-(void)showAlertViewToAddSemester
{
    UIAlertView *alert;
    //Wenn kein Semester vorhanden ist, kann der User nicht abbrechen
    if ([semesterArray count]!=0) {
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add semester", nil)
                                         message:nil
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                               otherButtonTitles:NSLocalizedString(@"Done", nil), nil];
    } else {
        alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add semester", nil)
                                         message:nil
                                        delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:NSLocalizedString(@"Done", nil), nil];
    }
    
    
    [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Name"];
    [alert show];
}

//Wenn ein Semester-Name geändert wird, dann kann man ihn nur ändern, wenn etwas im TextField eingegeben wurde!
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput && [alertView.title isEqualToString:    NSLocalizedString(@"Change name", nil)]) {
        if([[[alertView textFieldAtIndex:0] text] length] >= 1 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else{
        return YES;
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
            [self deleteSemesterAtIndexPath:currentIndexPathToDelete];
            if  (buttonIndex == 0) {
                
                if ([alertView.title isEqualToString:NSLocalizedString(@"Confirmation", nil)]) {
                    // User will Semester nicht löschen
                    [self setEditing:NO animated:YES];
                }
            }

        }
        
        
    
    
    if ([alertView.title isEqualToString:    NSLocalizedString(@"Change name", nil)
         ] && buttonIndex ==1)
    {
        Semester *semester = objc_getAssociatedObject(alertView, MyConstantKey);
        NSString *newSemesterName= [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text].capitalizedString;
        if ([semester.name isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"semester"]]){
            [[NSUserDefaults standardUserDefaults]setObject:newSemesterName forKey:@"semester"];
        }
        
        semester.name =newSemesterName;
        [self updateSemesterArray];
        [self.tableView reloadData];

    }

}



@end

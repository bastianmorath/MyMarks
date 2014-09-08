//
//  MMChooseSemester.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMChooseSemesterVC.h"

@interface MMChooseSemesterVC ()

@end

@implementation MMChooseSemesterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];

    //Rechter Button erstellen
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAlertView)];

    self.navigationItem.leftBarButtonItem = [MMFactory backBarButtonItemForClass:self];

    //Scrollen im TabelView verhindern
    [[self tableView]setBounces:NO];
    
    semesterArray = [[NSArray alloc]init];
    [self updateSemesterArray];
    
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
    return NO;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Entfernen des zu löschendem Elements aus dem Datenspeicher
       
        [[DataStore defaultStore] deleteObject:[semesterArray objectAtIndex:indexPath.row]];
        [self updateSemesterArray];
        [self.tableView reloadData];
    }
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



#pragma mark - AlertView

//Hinzufügen einer Prüfung
-(void)showAlertView
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Semester hinzufügen"
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Abbrechen"
                                        otherButtonTitles:@"Fertig", nil];
    [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Name"];
    [alert show];
}


//Methode, die aufgerufen wird, wenn ein Button des AlertViews gedrückt wird
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //Diese if-Schlaufe wird durchlaufen, wenn der AlertView des "Prüfung hinzufügen" aufgerufen wird
        if ([alertView.title isEqualToString:@"Semester hinzufügen"])
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
}



@end

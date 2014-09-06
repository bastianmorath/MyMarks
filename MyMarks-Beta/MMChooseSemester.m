//
//  MMChooseSemester.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMChooseSemester.h"

@interface MMChooseSemester ()

@end

@implementation MMChooseSemester

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Navigation-Title auf weisse Schrift setzen
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];


    //Rechter Button erstellen
    self.navigationItem.rightBarButtonItem= [MMFactory editIconItemForClass:self];;
    
    //Scrollen im TabelView verhindern
    [[self tableView]setBounces:NO];
    
    //"Zurück-Button"-Titel des Navigation-Controllers ändern
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Zurück" style: UIBarButtonItemStyleBordered target: self action: @selector(backPressed)];
    //[[self navigationItem] setBackBarButtonItem: newBackButton];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    semesterArray = [[NSMutableArray alloc]init];
    [semesterArray addObject:@"Semester 1"];
    [semesterArray addObject:@"Semester 2"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];

    
}

-(void)backPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];

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
    
    cell.textLabel.text = [semesterArray objectAtIndex:indexPath.row];
    
    
    return cell;
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
        //Entfernen des zu löschendem Elements aus dem Datenspeicher
        [semesterArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self viewWillAppear:YES];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
 
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row >=[semesterArray count])
    {
        return NO;
    }
    return YES;
}

//Verhindern, dass durch Swipen über die Zeile Zellen gelöscht werden können
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [semesterArray count])
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
    self.navigationItem.rightBarButtonItem= [MMFactory editIconItemForClass:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - AlertView

//Hinzufügen einer Prüfung
-(void)addSubject
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
                
                [semesterArray addObject:name];
                
                [self.tableView reloadData];
            }
        }
    }
}


#pragma  mark - Action Sheet

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"Neues Semester hinzufügen",@"Semester editieren", nil];
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
    
    }


@end

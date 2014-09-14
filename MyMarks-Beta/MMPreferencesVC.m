//
//  MMPreferencesTableViewController.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//



///////  Dynamic Cells!!!
//NSLog(@"section 0, %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"calculationType"]);
//if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"calculationType"] isEqualToNumber:@0]) {
//    tempLabel.text = @" Pluspunkte";
//} else {
//    NSLog(@"Durchscnitt");
//    tempLabel.text = @" Durchschnitt";
//}
#import "MMPreferencesVC.h"

@interface MMPreferencesVC ()

@end

@implementation MMPreferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];

   // self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:28/255.0f green:125/255.0f blue:253/255.0f alpha:1];

    //Titel setzen
    self.navigationItem.titleView = [MMFactory getNavigationViewForString:NSLocalizedString(@"Preferences", nil)];

    //Rechtes BarbuttonItem setzen
    [self.navigationItem setRightBarButtonItem:[[MMBarButtonItem alloc]initWithText:@"Done" target:self Position:PTRight] animated:YES];
    
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];

    
    //Schwarzer Strich am unteren Ende der Navigationbar entfernen
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];

    
    //**Google Analytics**//
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"MMPreferencesVC"];
    
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Gibt die Anzahl Section zurück
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    switch (indexPath.row) {
       
            
        case 0:
        {
            CellIdentifier = @"semesterCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"semester"];
            cell.accessoryView.tintColor = [UIColor whiteColor];
            cell.textLabel.text = NSLocalizedString(@"Semester", nil);
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
        }
            break;
            
        case 1:
        {
            CellIdentifier = @"iCloudCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.accessoryView.tintColor = [UIColor whiteColor];
            cell.textLabel.text = @"iCloud Synchronisation";
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
  
            
        }
            break;
            
        case 2:
        {
            CellIdentifier = @"mailCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.accessoryView.tintColor = [UIColor whiteColor];
            cell.textLabel.text = NSLocalizedString(@"Send Mail To Developers", nil);
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
        }
            break;
            
        case 3:
        {
            CellIdentifier = @"reviewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.accessoryView.tintColor = [UIColor whiteColor];
            cell.textLabel.text = NSLocalizedString(@"Review MyMarks in the AppStore", nil);
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
        }
            break;


            
        default:
            break;
    }
    
    
    return cell;
}


-(void)rightBarButtonItemPressed{
    NSLog(@"Dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"chooseCalculationType"]) {
        NSLog(@"Type");
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
            
            
        case 2:
        {
            
            [self sendMailToDevelopers];
        }
            break;
            
        case 3:
        {
            
            [self reviewAppInAppstore];
        }
            break;
            
    }
            
    

}

-(void) reviewAppInAppstore
{
    NSLog(@"review App");
    
}


-(void) sendMailToDevelopers
{
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"MyMarks - Question"];
    [mailComposer setToRecipients:@[@"bf.morath@gmail.com"]];
    [self presentViewController:mailComposer animated:YES completion:nil];
}
     
#pragma mark - mail compose delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}







@end















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

    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:28/255.0f green:125/255.0f blue:253/255.0f alpha:1];

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


//Diese Methode setzt die Titel der Sections auf weisse Schrift
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,3000,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:17];
    tempLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
  
    tempLabel.text=NSLocalizedString(@"Semester", nil);
   
    
    [tempView addSubview:tempLabel];
    return tempView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Gibt die Anzahl Section zurück
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    switch (indexPath.section) {
       
            
        case 0:
        {
            CellIdentifier = @"semesterCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"semester"];
            cell.accessoryView.tintColor = [UIColor whiteColor];
        }
            break;
            
        case 1:
        {
            CellIdentifier = @"iCloudCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}


-(void)rightBarButtonItemPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"chooseCalculationType"]) {
        NSLog(@"Type");
    }
}
@end

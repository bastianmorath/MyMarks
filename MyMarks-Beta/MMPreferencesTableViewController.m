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
#import "MMPreferencesTableViewController.h"

@interface MMPreferencesTableViewController ()

@end

@implementation MMPreferencesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];

    //Titel setzen
    self.navigationItem.titleView = [MMFactory getNavigationViewForString:NSLocalizedString(@"Preferences", nil)];

    //Rechtes BarbuttonItem setzen
    [self.navigationItem setRightBarButtonItem:[[MMBarButtonItem alloc]initWithText:@"Done" target:self Position:PTRight] animated:YES];
    
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - Table view data source


//Diese Methode setzt die Titel der Sections auf weisse Schrift
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0,100,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica Light" size:15];
    
    switch (section) {
        case 0:
        tempLabel.text = @"  Calculation Type";
            break;
            
        case 1:
            tempLabel.text=@"  Semester";
            break;
            
        case 2:
            tempLabel.text=@"  iCloud";
            break;
        default:
            break;
    }

    
    return tempLabel;
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
@end

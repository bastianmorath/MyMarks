//
//  MMPreferencesTableViewController.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMPreferencesTableViewController.h"

@interface MMPreferencesTableViewController ()

@end

@implementation MMPreferencesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    //Rechtes BarbUttonItem setzen
    [self.navigationItem setRightBarButtonItem:[[MMBarButtonItem alloc]initWithText:@"Done" target:self Position:PTRight] animated:YES];
    
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//Diese Methode setzt die Titel der Sections auf weisse Schrift
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0,100,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica Light" size:15];
    
    switch (section) {
        case 0:
            tempLabel.text=@" Pluspunkte";
            break;
            
        case 1:
            tempLabel.text=@" Semester";
            break;
            
        case 2:
            tempLabel.text=@" iCloud";
            break;
        default:
            break;
    }

    
    return tempLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
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

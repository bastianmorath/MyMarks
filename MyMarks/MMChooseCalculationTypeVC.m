//
//  MMChooseCalculationType.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMChooseCalculationTypeVC.h"

@interface MMChooseCalculationTypeVC ()

@end

@implementation MMChooseCalculationTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [MMFactory backBarButtonItemForClass:self];

    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Calculation Type", nil)];

    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    
    //**Google Analytics**//
    [MMFactory initGoogleAnalyticsForClass:self];
}



-(NSNumber *)checkedIndexPath{
    NSNumber  *checkedIndex;
    NSString *calcString =[[NSUserDefaults standardUserDefaults] objectForKey:@"calculationType"];;
    if ([calcString isEqualToString:@"Average"]) {
        checkedIndex = @0;
    }
    if ([calcString isEqualToString:@"Pluspoints"]) {
        checkedIndex = @1;
    }
    
    return checkedIndex;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([@(indexPath.row) isEqualToNumber:[self checkedIndexPath]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    switch (indexPath.row) {
        case 0:
        {
            cell = self.pluspointsCell;
            cell.textLabel.text = NSLocalizedString(@"Average", nil);
        }
            break;
        case 1:
        {
            cell = self.averageCell;
            cell.textLabel.text = NSLocalizedString(@"Pluspoints", nil);
        }
            break;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    int secondRow = indexPath.row ==1 ? 0 : 1;
    NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:secondRow inSection:0];
    UITableViewCell *secondCell = [tableView cellForRowAtIndexPath:secondIndexPath];


    
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    secondCell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"Average", nil)  forKey:@"calculationType"];
    }
    if (indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:NSLocalizedString(@"Pluspoints", nil) forKey:@"calculationType"];
    }
}


-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

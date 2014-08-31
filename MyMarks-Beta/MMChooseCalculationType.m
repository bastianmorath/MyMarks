//
//  MMChooseCalculationType.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import "MMChooseCalculationType.h"

@interface MMChooseCalculationType ()

@end

@implementation MMChooseCalculationType

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

-(NSNumber *)checkedIndexPath{
    NSNumber  *checkedIndex= [[NSUserDefaults standardUserDefaults] objectForKey:@"calculationType"];
    return checkedIndex;
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"celForRow");
      UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
 
    switch (indexPath.row) {
        case 0:
            cell = self.pluspointsCell;
            break;
        case 1:
            cell = self.averageCell;
            break;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([[self checkedIndexPath] isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"calculationType"];
}


@end

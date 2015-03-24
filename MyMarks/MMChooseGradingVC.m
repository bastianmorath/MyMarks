//
//  MMChooseGradingVCTableViewController.m
//  MyMarks
//
//  Created by Bastian Morath on 23/03/15.
//  Copyright (c) 2015 Bastian Morath. All rights reserved.
//

#import "MMChooseGradingVC.h"
@interface MMChooseGradingVC ()

@end

@implementation MMChooseGradingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [MMFactory backBarButtonItemForClass:self];
    //Background setzen
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    [self.tableView setBackgroundView:backgroundView];
    
    //Scrollen im TabelView verhindern
    [[self tableView]setBounces:NO];
    
    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Choose grading", nil)];
    self.gradingArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < kNumberOfObjects; ++i){
        [self.gradingArray addObject:[MMFactory formatTypeToString:i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


@end

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
    
    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Grading", nil)];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.gradingArray.count+1 >[MMFactory numberOfRows] ? self.gradingArray.count+1 : [MMFactory numberOfRows]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 2*[MMFactory heightOfRow];
    }
    return [MMFactory heightOfRow];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell konfigurieren
    if (indexPath.row == 0){
        // Description Cell
        MMSubtitleCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subtitleCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MMSubtitleCellTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        cell.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
        
       //  cell.titleLabel.text = @"Description";
        if  ([[[NSUserDefaults standardUserDefaults] objectForKey:@"grading"]isEqualToNumber:@0])
        {
            cell.subtitleLabel.text = NSLocalizedString(@"Average description", nil);

        } else {
            cell.subtitleLabel.text = NSLocalizedString(@"AverageAndPluspoints description", nil);
        }

        [self setColorOfCell:cell andIndexPath:indexPath];
        return cell;

    }else if (indexPath.row<self.gradingArray.count+1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];

        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.userInteractionEnabled = YES;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        cell.textLabel.text = self.gradingArray[indexPath.row-1];
        NSNumber *indexPathNumber = [NSNumber numberWithInt:indexPath.row-1];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"grading"]isEqualToNumber:indexPathNumber])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [self setColorOfCell:cell andIndexPath:indexPath];

        return cell;

    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]init];

        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        [self setColorOfCell:cell andIndexPath:indexPath];
        return cell;

    }
    
}

-(void)setColorOfCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {
    //Farbverlauf bestimmen
    //Je nach dem, ob weniger/gleich oder mehr als 10 Fächer eingetragen wurden(bei über 10 verlassen die untersten Zellen den Screen), wird der Farbverlauf der Zellen anderst konfiguriert
    double redColor =   41  + (indexPath.row * 116/([MMFactory numberOfRows]-1));
    double greenColor = 135 + (indexPath.row * 94/([MMFactory numberOfRows]-1));
    double blueColor =  241 - (indexPath.row * 110/([MMFactory numberOfRows]-1));
    
    cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= self.gradingArray.count){
        NSNumber *grading = [NSNumber numberWithInt:indexPath.row-1];
        [[NSUserDefaults standardUserDefaults] setObject:grading forKey:@"grading"];
        [self.tableView reloadData];
    }
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

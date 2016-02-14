//
//  MMPreferencesTableViewController.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//



#import "MMPreferencesVC.h"

@interface MMPreferencesVC () <UIScrollViewDelegate>

@end

@implementation MMPreferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Titel setzen
    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Preferences", nil)];

    //Barbutton-Items auf weisse Schrift setzen
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];

    //NavigationBar Background setzen
    UIView *addStatusBar = [[UIView alloc] init];
    addStatusBar.frame = CGRectMake(0, 0, 320, 20);
    [addStatusBar setBackgroundColor:[MMFactory blueColor]];
    [self.navigationController.view addSubview:addStatusBar];
    [self.navigationController.navigationBar setBackgroundColor:[MMFactory blueColor]];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    [self.tableView setBackgroundView:backgroundView];
    
    //Schwarzer Strich am unteren Ende der Navigationbar entfernen
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    //Rechtes BarbuttonItem setzen
    [self.navigationItem setRightBarButtonItem:[[MMBarButtonItem alloc]initWithText:NSLocalizedString(@"Done", nil) target:self Position:PTRight] animated:YES];
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
   
    return [MMFactory numberOfRows];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       return [MMFactory heightOfRow];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    switch (indexPath.row)
    {
        case 0:
        {
            CellIdentifier = @"semesterCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"semester"];
            cell.textLabel.text = NSLocalizedString(@"Semester", nil);
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
        }
            break;
    
        case 1:
        {
            CellIdentifier = @"gradingCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"grading"];
            cell.textLabel.text = NSLocalizedString(@"Grading", nil);
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
        }
            break;
        
        case 2:
        {
            CellIdentifier = @"textCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"Write a review in the AppStore", nil);
        }
            break;

            
        default:
        {
            CellIdentifier = @"textCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }
            break;
    }
    
    //Farbverlauf bestimmen
    double redColor =   41  + (indexPath.row * 116/([MMFactory numberOfRows]-1));
    double greenColor = 135 + (indexPath.row * 94/([MMFactory numberOfRows]-1));
    double blueColor =  241 - (indexPath.row * 110/([MMFactory numberOfRows]-1));

    cell.backgroundColor = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:1];
    
    return cell;
}


-(void)rightBarButtonItemPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if (indexPath.row == 2)
        {
            [self reviewAppInAppstore];
        }
}

-(void)reviewAppInAppstore
{
    // FIXME: itunes aktualisieren
    NSString *url = @"https://itunes.apple.com/de/app/mymarks/id736015615?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end















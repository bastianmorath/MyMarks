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
    
    //Titel setzen
    self.navigationItem.titleView = [MMFactory navigationViewForString:NSLocalizedString(@"Preferences", nil)];

    //Barbutton-Items auf weisse Schrift setzen
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
    //Background setzen
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IPhone5_Background.png"]];
    
    //Schwarzer Strich am unteren Ende der Navigationbar entfernen
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    //Rechtes BarbuttonItem setzen
    [self.navigationItem setRightBarButtonItem:[[MMBarButtonItem alloc]initWithText:NSLocalizedString(@"Done", nil) target:self Position:PTRight] animated:YES];
    
    

    
    //**Google Analytics**//
    [MMFactory initGoogleAnalyticsForClass:self];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
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
            cell.textLabel.text = NSLocalizedString(@"Send Mail To Developers", nil);
        }
            break;
            
        case 3:
        {
            CellIdentifier = @"reviewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"Review MyMarks in the AppStore", nil);
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
    NSString *url = @"https://itunes.apple.com/de/app/mymarks/id736015615?mt=8"; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


-(void) sendMailToDevelopers
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer.view setTintColor:[UIColor whiteColor]];


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















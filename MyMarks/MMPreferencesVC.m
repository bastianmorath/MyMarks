//
//  MMPreferencesTableViewController.m
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//



#import "MMPreferencesVC.h"

@interface MMPreferencesVC () <ABXPromptViewDelegate>

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
    
    

    
    //**Google Analytics**//
    [MMFactory initGoogleAnalyticsForClass:self];
    
//    // The prompt view is an example workflow using AppbotX
//    // It's also good to only show it after a positive interaction
//    // or a number of usages of the app
//    if (![ABXPromptView hasHadInteractionForCurrentVersion]) {
//        self.promptView = [[ABXPromptView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 160, CGRectGetWidth(self.view.bounds), 100)];
//        self.promptView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//        [self.tableView addSubview:self.promptView];
//        self.promptView.delegate = self;
//    }

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
    if (self.promptView){
        return [MMFactory numberOfRows]-1;
    }

    return [MMFactory numberOfRows];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.promptView && indexPath.row == [MMFactory numberOfRows]-2){
        return [MMFactory heightOfRow]*2;
    }
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
            CellIdentifier = @"textCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"Version history", nil);

            
        }
            break;
            
        case 2:
        {
            CellIdentifier = @"textCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"Send a mail to developers", nil);
                   }
            break;
        
        case 3:
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

    switch (indexPath.row)
    {
            
            
        case 1:
        {
            ABXVersionsViewController *controller = [[ABXVersionsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
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

-(void)reviewAppInAppstore
{
    NSString *url = @"https://itunes.apple.com/de/app/mymarks/id736015615?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


-(void) sendMailToDevelopers
{
//    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
//    mailComposer.mailComposeDelegate = self;
//    [mailComposer.view setTintColor:[UIColor whiteColor]];
//
//
//    [mailComposer setSubject:@"MyMarks"];
//    [mailComposer setToRecipients:@[@"bf.morath@gmail.com"]];
//    [self presentViewController:mailComposer animated:YES completion:nil];
    ABXFeedbackViewController *controller = [[ABXFeedbackViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
     
#pragma mark - mail compose delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result)
    {
        NSLog(@"Result : %d",result);
    }
    if (error)
    {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)chooseGrading{

}


- (void)appbotPromptForReview
{
    NSString *url = @"https://itunes.apple.com/de/app/mymarks/id736015615?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    self.promptView = nil;
    self.promptView.hidden = YES;
}

- (void)appbotPromptForFeedback
{
    [ABXFeedbackViewController showFromController:self placeholder:nil];
    self.promptView = nil;
    self.promptView.hidden = YES;

}

- (void)appbotPromptClose
{
    self.promptView = nil;
    self.promptView.hidden = YES;

}



@end















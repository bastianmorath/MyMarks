//
//  MMPreferencesTableViewController.h
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ABXPromptView.h"

@interface MMPreferencesVC : UITableViewController<MFMailComposeViewControllerDelegate>


@property ABXPromptView *promptView;


@end

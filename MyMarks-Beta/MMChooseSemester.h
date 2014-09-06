//
//  MMChooseSemester.h
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMChooseSemester : UITableViewController <UITableViewDelegate,UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{

    NSMutableArray *semesterArray;

}

- (void)editPressed;
- (void)donePressed;

@end

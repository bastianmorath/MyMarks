//
//  MMChooseSemester.h
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMChooseSemesterVC : UITableViewController <UITableViewDelegate,UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>
{
    NSArray *semesterArray;
}

-(void)updateSemesterArray;


@end

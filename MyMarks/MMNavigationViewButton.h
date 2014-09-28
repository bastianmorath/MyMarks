//
//  MMNavigationViewButton.h
//  Notenapplikation
//
//  Created by Bastian Morath on 06/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMNavigationViewButton : UIButton
{
    UILabel *label;
    UILabel *tapLabel;
}
@property (nonatomic) enum buttonType type;

//Updatet den View, wird aufgerufen, wenn neue Prüfungen oder Fächer hinzugefügt werden
-(void)update;
//Wechselt zwischen Average und Pluspoints
-(void)changeType;

//Updatet den angezeigten Text
-(void)updateText;


//Das Semester, welches der Button repräsentiert
@property (nonatomic, assign) MMSemester *semester;
-(instancetype)initWithTarget:(id)class;

@end

//
//  Enumerations.h
//  AntumTrainer
//
//  Created by Bastian Morath on 23/06/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMEnumerations : NSObject


/*ButtonType*/
enum buttonType {
    BTAverage,
    BTPluspoints,
};

enum ATPosition{
    PTLeft,
    PTRight
};

enum GradingType{
    kAverage,
    kAverageAndPluspoints,
    kNumberOfObjects
};
@end

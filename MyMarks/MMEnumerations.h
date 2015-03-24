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
typedef enum buttonType {
    BTAverage,
    BTPluspoints,
    BTUSA,
    BTGPA
};

typedef enum ATPosition{
    PTLeft,
    PTRight
};

typedef enum GradingType{
    kAverage,
    kAverageAndPluspoints,
    kAverageAndUSA,
    kAverageAndGPA,
    kNumberOfObjects
};
@end

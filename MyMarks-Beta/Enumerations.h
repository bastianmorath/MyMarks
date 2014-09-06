//
//  Enumerations.h
//  AntumTrainer
//
//  Created by Bastian Morath on 23/06/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enumerations : NSObject


/*ButtonType*/
typedef enum buttonType {
    BTAverage,
    BTPluspoints
};

/*ButtonType*/
typedef enum iconType {
    ITCalendarIcon,
    ITDeleteIcon,
    ITEditIcon,
    ITFilesIcon,
    ITLibraryIcon,
    ITListIcon,
    ITMessagesIcon,
    ITRateIcon,
    ITSettingsIcon,
    ITShareIcon,
    ITClockIcon
};



typedef enum ATPosition{
    PTLeft,
    PTRight
};


@end

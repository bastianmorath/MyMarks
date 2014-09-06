//
//  Enumerations.h
//  AntumTrainer
//
//  Created by Bastian Morath on 23/06/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enumerations : NSObject

/*CellType*/
typedef enum cellType {
    CTTimestamp,
    CTName,
    CTTimestampAndName,
    CTLetter
};

/*ButtonType*/
typedef enum buttonType {
    BTText,
    BTIcon,
    BTIconAndText,
    BTImage
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

typedef enum cellPosition{
    CPLeft,
    CPRight
};

typedef enum ATPosition{
    PTLeft,
    PTRight
};


@end

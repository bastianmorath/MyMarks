//
//  Exam.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der Exam-Klasse wurde von Florian erstellt

#import "Exam.h"

@implementation Exam


- (id)init
{
    self = [super init];
    if ((self)) {
        self.mark = 0.0;
        self.weighting = 0.0;
        self.date = [[NSDate alloc]init];
        self.notes = [[NSString alloc]init];
    }
    return self;
}


// Diese folgenden zwei Methoden sind dafür zuständig, dass der NSKeyedUnarchiver und NSKeyArchiver (siehe AppDelegate) wissen, wie sie die Objekte speichern sollen
- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSNumber *tempMark      = [[NSNumber alloc] initWithDouble:self.mark];
    NSNumber *tempWeighting = [[NSNumber alloc] initWithDouble:self.weighting];
    
    //Encode properties
    [encoder encodeObject:tempMark      forKey:@"mark"];
    [encoder encodeObject:tempWeighting forKey:@"weighting"];
    [encoder encodeObject:self.date     forKey:@"date"];
    [encoder encodeObject:self.notes    forKey:@"notes"];
    
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        NSNumber *tempMark      = [decoder decodeObjectForKey:@"mark"];
        NSNumber *tempWeighting = [decoder decodeObjectForKey:@"weighting"];
        
        //Decode properties
        self.mark      = [tempMark doubleValue];
        self.weighting = [tempWeighting doubleValue];
        self.date      = [decoder decodeObjectForKey:@"date"];
        self.notes     = [decoder decodeObjectForKey:@"notes"];
        
    }
    return self;
}


@end

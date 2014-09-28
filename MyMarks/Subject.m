//
//  Subject.m

//
//  Copyright (c) 2013 Bastian Morath and Florian Morath. All rights reserved.

//  Dieses Implementation-File der Klasse Subject wurde von Florian erstellt.


#import "Subject.h"

@implementation Subject


- (id)init
{
    self = [super init];
    if ((self)) {
        self.examArray = [[NSMutableArray alloc]init];
        self.average = 0.0;
        self.subjectName = [[NSString alloc]init];
    }
    return self;
}


// Diese folgenden zwei Methoden sind dafür zuständig, dass der NSKeyedUnarchiver und NSKeyArchiver (siehe AppDelegate) wissen, wie sie die Objekte speichern/lesen sollen
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties
    [encoder encodeObject:self.examArray forKey:@"examArray"];
    [encoder encodeObject:self.subjectName forKey:@"subjectName"];
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties
        self.examArray = [decoder decodeObjectForKey:@"examArray"];
        self.subjectName = [decoder decodeObjectForKey:@"subjectName"];
    }
    return self;
}

@end

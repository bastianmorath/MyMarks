//
//  Semester.h
//  MyMarks
//
//  Created by Bastian Morath on 21/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MMSubject;

@interface MMSemester : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *subject;

-(float)average;
-(float)plusPoints;
-(NSString *)USAGrade;
@end

@interface MMSemester (CoreDataGeneratedAccessors)

- (void)addSubjectObject:(MMSubject *)value;
- (void)removeSubjectObject:(MMSubject *)value;
- (void)addSubject:(NSSet *)values;
- (void)removeSubject:(NSSet *)values;

@end

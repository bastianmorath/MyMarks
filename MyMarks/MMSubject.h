//
//  Subject.h
//  MyMarks
//
//  Created by Bastian Morath on 21/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MMExam;

@interface MMSubject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * weighting;
@property (nonatomic, retain) NSSet *exam;

-(float)average;

@end

@interface MMSubject (CoreDataGeneratedAccessors)

- (void)addExamObject:(MMExam *)value;
- (void)removeExamObject:(MMExam *)value;
- (void)addExam:(NSSet *)values;
- (void)removeExam:(NSSet *)values;

@end

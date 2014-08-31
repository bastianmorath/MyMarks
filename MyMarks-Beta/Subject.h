//
//  Subject.h
//  Notenapplikation
//
//  Created by Bastian Morath on 31/08/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exam;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * weighting;
@property (nonatomic, retain) NSSet *exam;

-(float)average;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addExamObject:(Exam *)value;
- (void)removeExamObject:(Exam *)value;
- (void)addExam:(NSSet *)values;
- (void)removeExam:(NSSet *)values;

@end

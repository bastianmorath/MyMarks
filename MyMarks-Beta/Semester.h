//
//  Semester.h
//  Notenapplikation
//
//  Created by Bastian Morath on 07/09/14.
//  Copyright (c) 2014 Bastian Morath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Semester : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *subject;
@end

@interface Semester (CoreDataGeneratedAccessors)

- (void)addSubjectObject:(Subject *)value;
- (void)removeSubjectObject:(Subject *)value;
- (void)addSubject:(NSSet *)values;
- (void)removeSubject:(NSSet *)values;

@end

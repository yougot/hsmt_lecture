//
//  Space.h
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Space : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *projects;
@end

@interface Space (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end

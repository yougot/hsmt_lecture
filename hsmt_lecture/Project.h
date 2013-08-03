//
//  Project.h
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSManagedObject *space;

@end

//
//  HLParser.m
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import "HLParser.h"
#import "Space.h"
#import "Project.h"
#import <NLCoreData.h>

@implementation HLParser

static HLParser *_sharedInstance;

+ (HLParser *)sharedInstance
{

    if (_sharedInstance == nil) {
        _sharedInstance = [[HLParser alloc] init];
        [_sharedInstance setupNotifications];
    }
    return _sharedInstance;

}

- (void)setupNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didReciveProjects:) name:@"backlog.getProjects" object:nil];
}

#pragma amrk - parser

- (void)didReciveProjects:(NSNotification *)notification
{
    NSMutableSet *projects = [NSMutableSet setWithCapacity:0];
    
    NSString *spaceName = nil;
    for (NSDictionary *object in notification.object)
    {
        NSNumber *project_id = @(((NSString *)object[@"id"]).intValue);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project_id=%@", project_id];
        
        Project *project = [Project fetchOrInsertSingleWithPredicate:predicate];
        project.project_id = project_id;
        project.name       = object[@"name"];
        project.key        = object[@"key"];
        project.url        = object[@"url"];
        [projects addObject:project];

        if (spaceName == nil) {
            spaceName = [[NSURL URLWithString:project.url] host];
            spaceName = [spaceName stringByReplacingOccurrencesOfString:@".backlog.jp" withString:@""];
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", spaceName];
    Space *space = [Space fetchSingleWithPredicate:predicate];
    [space addProjects:projects];
}


@end

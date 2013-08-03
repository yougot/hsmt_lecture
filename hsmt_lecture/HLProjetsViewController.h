//
//  HLProjetsViewController.h
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <XMLRPC.h>
#import "Space.h"

@interface HLProjetsViewController : UITableViewController <NSFetchedResultsControllerDelegate, XMLRPCConnectionDelegate>

@property (nonatomic, strong) Space *space;

@end

//
//  HLSpaceAddViewController.m
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import "HLSpaceAddViewController.h"
#import <NLCoreData.h>
#import "Space.h"

@interface HLSpaceAddViewController ()

@end

@implementation HLSpaceAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapDoneButton:(id)sender {
    
    Space *space = [Space insert];
    space.name = self.spaceName.text;
    space.userName = self.userName.text;
    space.password = self.password.text;
    [[NSManagedObjectContext mainContext] saveNested];
    
    [self performSegueWithIdentifier:@"unWindDone" sender:self];
}

@end

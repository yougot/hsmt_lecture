//
//  HLSpaceAddViewController.h
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLSpaceAddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *spaceName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)didTapDoneButton:(id)sender;

@end

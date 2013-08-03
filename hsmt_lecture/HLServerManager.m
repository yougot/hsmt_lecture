//
//  HLServerManager.m
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import "HLServerManager.h"
#import <SVProgressHUD.h>

@implementation HLServerManager

static HLServerManager *_sharedInstance;

+ (HLServerManager *)sharedInstance
{
    
    if (_sharedInstance == nil) {
        _sharedInstance = [[HLServerManager alloc] init];
    }
    return _sharedInstance;
    
}

#pragma mark - XML RPC delegate

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge proposedCredential]) {
        // do nothing
    } else {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.space.userName
                                                                 password:self.space.password
                                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:request.method object:response.object];

    [SVProgressHUD showSuccessWithStatus:@"完了"];
}

- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"失敗"];
    NSLog(@"%@", error);
}

#pragma mark - private method

- (void)requestWithMethod:(NSArray *)values
{
    NSString *urlString = [NSString stringWithFormat:@"https://%@.backlog.jp/XML-RPC", self.space.name];
    NSURL *URL = [NSURL URLWithString:urlString];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    for (NSDictionary *value in values) {
        NSString *parameter = value[@"parameter"];
        if ([parameter isEqualToString:@""]) parameter = nil;
        [request setMethod:value[@"method"] withParameter:parameter];
    }

    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
    
    [SVProgressHUD showWithStatus:@"取得中" maskType:SVProgressHUDMaskTypeGradient];
}

#pragma mark - public method

- (void)getProjets {
    
    NSArray *param = @[@{@"method" : @"backlog.getProjects", @"parameter" : @""}];
    [self requestWithMethod:param];
}

@end

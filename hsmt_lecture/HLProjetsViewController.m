//
//  HLProjetsViewController.m
//  hsmt_lecture
//
//  Created by 岡本 豊 on 2013/08/03.
//  Copyright (c) 2013年 karakurimono. All rights reserved.
//

#import "HLProjetsViewController.h"
#import "Project.h"
#import <NLCoreData.h>
#import <SVProgressHUD.h>

@interface HLProjetsViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedRC;
@end

@implementation HLProjetsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // NSFetchedResult Controller のセットアップ
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Project class]];
        [request sortByKey:@"project_id" ascending:YES];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"space.name=%@", self.space.name];
        NSLog(@"%@", predicate);
        [request setPredicate:predicate];
        
        self.fetchedRC = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                             managedObjectContext:[NSManagedObjectContext mainContext]
                                                               sectionNameKeyPath:nil cacheName:nil];
        NSError *error = nil;
        if (![self.fetchedRC performFetch:&error]) {
            NSLog(@"%@", error);
        }
    }
    
    // XMLRequest
    {
        NSString *urlString = [NSString stringWithFormat:@"https://%@.backlog.jp/XML-RPC", self.space.name];
        NSURL *URL = [NSURL URLWithString:urlString];
        XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
        [request setMethod: @"backlog.getProjects" withParameter:nil];
        
        XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
        [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
        
        [SVProgressHUD showWithStatus:@"取得中" maskType:SVProgressHUDMaskTypeGradient];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
    }
    
    NSLog(@"Response body: %@", [response body]);
    [SVProgressHUD showSuccessWithStatus:@"完了"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.fetchedRC.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedRC.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

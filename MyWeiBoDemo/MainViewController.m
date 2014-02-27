//
//  MainViewController.m
//  MyWeiBoDemo
//
//  Created by rick on 14-2-26.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MainViewController ()

@end

@implementation MainViewController{
    MBProgressHUD *hud;
}

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
    
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    _array = [[NSMutableArray alloc] init];
    
    [self addRefreshController];
    
    [self getWeiboData:_page];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) getWeiboData:(int) page{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        hud = [[MBProgressHUD alloc] init];
        
        hud.dimBackground = YES;
        hud.labelText = @"正在加载数据....";
        [hud show:YES];
        [self.view addSubview:hud];
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSURL *url = [NSURL URLWithString:[InfoForSina returnFriendsTimelintURLString:page]];
            
            NSURLRequest *request = [NSURLRequest  requestWithURL:url];
            
            NSData *weiboData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            NSDictionary *weiboStatusDictionary = [NSJSONSerialization JSONObjectWithData:weiboData options:kNilOptions error:nil];
            
            //NSLog(@"weibo = %@", weiboStatusDictionary);
            if ([_array count] != 0) {
                [_array removeAllObjects];
            }
            
            [_array addObjectsFromArray:[weiboStatusDictionary objectForKey:@"statuses"]];
            for (NSDictionary *dictionary in _array) {
                Status *status = [[Status alloc] init];
                status = [status initWithJsonDictionary:dictionary];
                [_statusArray addObject:status];
            }
            NSLog(@"count = %d", [_statusArray count]);
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [hud removeFromSuperview];
        });
    });
}

-(void)addRefreshController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControllerEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)RefreshViewControllerEventValueChanged{
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
}

-(void)loadData{
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    [self getWeiboData:_page];
    if (self.refreshControl.refreshing == true) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    return [_statusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //NSLog(@"Configure the cell...");
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Status *status = nil;
    status = [self.statusArray objectAtIndex:[indexPath row]];
    if (cell != nil) {
        [cell removeFromSuperview];
    }
    cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setupCell:status];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Status *status = nil;
    status = [self.statusArray objectAtIndex:[indexPath row]];
    CGFloat yHeight = 70.0;
    
    CGSize contraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
    CGSize sizeOne = [status.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:contraint lineBreakMode:NSLineBreakByWordWrapping];
    yHeight += (sizeOne.height + CELL_CONTENT_MARGIN);
    
    //转发
    Status *retwitterStatus = status.retweetedStatus;
    if (status.hasRetwitter && ![retwitterStatus isEqual:[NSNull null]]) {
        NSString *retwitterContentText = [NSString stringWithFormat:@"%@%@", retwitterStatus.screenName, retwitterStatus.text];
        CGSize textSize = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
        CGSize sizeTwo = [retwitterContentText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        yHeight += (sizeTwo.height + CELL_CONTENT_MARGIN);
        
        if (status.haveRetwitterImage) {
            yHeight += (120 + CELL_CONTENT_MARGIN);
        }
    }else{
        //无转发
        if (status.hasImage) {
            yHeight += (120 + CELL_CONTENT_MARGIN);
        }
    }
    yHeight += 20;
    
    return yHeight;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _detailStatus = [_statusArray objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailController = [segue destinationViewController];
        
        detailController.status = _detailStatus;
        
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffsetPoint = self.tableView.contentOffset;
    CGRect frame = self.tableView.frame;
    if (contentOffsetPoint.y == self.tableView.contentSize.height - frame.size.height) {
        [self getWeiboData:++_page];
    }
}

- (IBAction)refreshButton:(id)sender {
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    [self getWeiboData:_page];
}
@end

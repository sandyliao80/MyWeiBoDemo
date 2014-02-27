//
//  FansViewController.m
//  MyWeiBoDemo
//
//  Created by rick on 14-2-25.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import "FansViewController.h"
#import "InfoForSina.h"
#import "FansCell.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface FansViewController ()

@end

@implementation FansViewController
{
    int nextCursor;
    NSInteger followsCount;
    MBProgressHUD *hud;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    //self = [super init];
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
    _followsMutableArray = [[NSMutableArray alloc] init];
    nextCursor = 0;
    [self loadfFollowersDataWithCursor:nextCursor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadfFollowersDataWithCursor:(int) cursor{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            hud = [[MBProgressHUD alloc] init];
            hud.dimBackground = YES;
            hud.labelText = @"正在加载数据...";
            [hud show:YES];
            [self.view addSubview:hud];
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[InfoForSina returnFollowersUrlStringWithCursor:cursor]]];
            
            NSError *error;
            NSData *followersData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            
            __autoreleasing NSError *_error;
            NSDictionary *followersDictionary = [NSJSONSerialization JSONObjectWithData:followersData options:kNilOptions error:&_error];
            
            //NSLog(@"followes = %@", followersDictionary);
            
            NSArray *followersArray = followersDictionary[@"users"];
            followsCount = [followersDictionary[@"total_number"] integerValue];
            nextCursor   = [followersDictionary[@"next_cursor"] integerValue];
            NSLog(@"nextCursor is :%d",nextCursor);
            
            for (NSDictionary *dictionary in followersArray) {
                User *followerUser = [[User alloc] init];
                [followerUser initUserWithDictionary:dictionary];
                [self.followsMutableArray addObject:followerUser];
                //NSLog(@"follower = %@", dictionary);
            }
            NSLog(@"followsMutableArray = %@", self.followsMutableArray);
            
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [hud removeFromSuperview];
        });
    });
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
    
    return [self.followsMutableArray count];
    //return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FansCell";
    //[self.tableView registerClass:[FansCell class] forCellReuseIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    User *aUser = [[User alloc] init];
    aUser = [_followsMutableArray objectAtIndex:[indexPath row]];
    
    cell.nameLabel.adjustsFontSizeToFitWidth = YES;
    cell.nameLabel.text = aUser.nameString;
    
    cell.fansButtonLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (aUser.following) {
        [cell.fansButtonLabel setTitle:@"互相关注" forState:UIControlStateNormal];
    }else{
        [cell.fansButtonLabel setTitle:@"+关注" forState:UIControlStateNormal];
    }
    
    __block NSData *imageData;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:aUser.profileImageURL]];
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [cell.imageView setImage:image];
        });
        
    });
    
    CALayer *l = [cell.imageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    
    cell.fansUIDString = aUser.IDString;
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffPoint = self.tableView.contentOffset;
    CGRect frame = self.tableView.frame;
    if (contentOffPoint.y == self.tableView.contentSize.height - frame.size.height) {
        //NSLog(@"scroll ded scroll----");
        if (nextCursor != 0) {
            [self loadfFollowersDataWithCursor:nextCursor];
        }else{
            MBProgressHUD *endHud = [[MBProgressHUD alloc] init];
            endHud.mode = MBProgressHUDModeText;
            endHud.labelText = @"提示";
            endHud.detailsLabelText = @"粉丝数据已经全部加载!";
            
            [self.tableView addSubview:endHud];
            [endHud show: YES];
            [endHud hide:YES afterDelay:0.5];
        }
    }
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

//
//  DetailViewController.m
//  MyWeiBoDemo
//
//  Created by rick on 14-2-26.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "CommentCreateViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface DetailViewController ()

@end

@implementation DetailViewController{
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSLog(@"detail = %@", _status);
    _commentArray = [[NSMutableArray alloc] init];
    _page = 1;
    hud = [[MBProgressHUD alloc] init];
    
    [self continueLoadData:1];
}

-(NSString *)getTimeString:(NSString *)string{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}

-(void)continueLoadData:(int)page{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            hud.labelText = @"正在加载评论数据....";
            [hud show:YES];
            [self.view addSubview:hud];
            
            NSString *urlString = [InfoForSina returnCommentUrlStringWithID:_status.statusId page:_page];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *commentListData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            
            NSDictionary *dataListDictionary = [NSJSONSerialization JSONObjectWithData:commentListData options:kNilOptions error:nil];
            
            //NSLog(@"comment json = %@", dataListDictionary[@"comments"]);
            _totalNum = [dataListDictionary[@"total_number"] integerValue];
            [_commentArray addObjectsFromArray:dataListDictionary[@"comments"]];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [hud removeFromSuperview];
        });
    });
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
    return 1 + [_commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        WeiboCell *cell = [[WeiboCell alloc] init];
        [cell setupCell:_status];
        return cell;
    }else{
        static NSString *CellIdentifier = @"detailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //if (cell != nil) {
            //[cell removeFromSuperview];
        //}
        
        NSDictionary *dictionary = [_commentArray objectAtIndex:indexPath.row -1];
        NSString *timeString = dictionary[@"created_at"];
        NSString *commentString = dictionary[@"text"];
        
        NSDictionary *user = dictionary[@"user"];
        NSString *userName = user[@"screen_name"];
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [userNameLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        
        [userNameLabel setText:userName];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        [userNameLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, 160, 30)];
        userNameLabel.tag = 100;
        
        [[cell viewWithTag:100] removeFromSuperview];
        [[cell contentView] addSubview:userNameLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        
        [timeLabel setText:[self getTimeString:timeString]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        [timeLabel setFrame:CGRectMake(170, CELL_CONTENT_MARGIN, 140, 20)];
        timeLabel.tag = 101;
        
        [[cell viewWithTag:101] removeFromSuperview];
        [[cell contentView] addSubview:timeLabel];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [commentLabel setNumberOfLines:0];
        [commentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        
        CGSize contraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
        CGSize size = [commentString sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:contraint lineBreakMode:NSLineBreakByWordWrapping];
        [commentLabel setText:commentString];
        
        [commentLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, 30 + 2*CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height)];
        commentLabel.tag = 102;
        [[cell viewWithTag:102] removeFromSuperview];
        [[cell contentView] addSubview:commentLabel];
        
        return cell;
    }
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    //return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        //
        //高度设置
        CGFloat yHeight = 70.0;
        
        //微博的内容的高度
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
        CGSize sizeOne = [_status.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        yHeight += (sizeOne.height + CELL_CONTENT_MARGIN);
        
        //转发情况
        Status  *retwitterStatus = _status.retweetedStatus;
        
        //有转发
        if (_status.hasRetwitter && ![retwitterStatus isEqual:[NSNull null]])
        {
            
            //转发内容的文本内容
            NSString *retwitterContentText = [NSString stringWithFormat:@"%@:%@",retwitterStatus.screenName,retwitterStatus.text];
            CGSize textSize = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
            CGSize sizeTwo = [retwitterContentText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
            
            yHeight += (sizeTwo.height + CELL_CONTENT_MARGIN);
            
            //那么图像就在转发部分进行显示
            if (_status.haveRetwitterImage) //转发的微博有图像
            {
                yHeight += (120 + CELL_CONTENT_MARGIN);
            }
        }
        //无转发
        else
        {
            //微博有图像
            if (_status.hasImage) {
                
                yHeight += (120+ CELL_CONTENT_MARGIN);
            }
        }
        yHeight += 20;
        return yHeight;
    }else{
        NSDictionary *dictionary = [_commentArray objectAtIndex:indexPath.row - 1];
        NSString *commentString = dictionary[@"text"];
        CGSize contraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN*2), MAXFLOAT);
        CGSize size = [commentString sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:contraint lineBreakMode:NSLineBreakByWordWrapping];
        return 30 + 3*CELL_CONTENT_MARGIN + size.height;
        
    }
    
    return 1;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffSetPoint = self.tableView.contentOffset;
    CGRect frame = self.tableView.frame;
    if (contentOffSetPoint.y == self.tableView.contentSize.height - frame.size.height) {
        if (_totalNum <= 50 || _page > (_totalNum/50+1)) {
            MBProgressHUD *endHud = [[MBProgressHUD alloc] init];
            endHud.mode = MBProgressHUDModeText;
            endHud.labelText = @"提示";
            endHud.detailsLabelText = @"没有更多的评论了!";
            [self.tableView addSubview:endHud];
            [endHud show:YES];
            [endHud hide:YES afterDelay:1];
        }else{
            [self continueLoadData:++_page];
        }
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"commentSegue"]) {
        CommentCreateViewController *vc = [segue destinationViewController];
        vc.weiboID = _status.statusId;
    }
}



@end

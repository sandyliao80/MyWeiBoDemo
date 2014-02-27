//
//  DetailViewController.h
//  MyWeiBoDemo
//
//  Created by rick on 14-2-26.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "WeiboCell.h"
#import "InfoForSina.h"
#import "MBProgressHUD.h"
//#import "<#header#>"

@interface DetailViewController : UITableViewController

@property (nonatomic, strong) Status *status;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic) NSInteger totalNum;
@property (nonatomic) int page;

@end

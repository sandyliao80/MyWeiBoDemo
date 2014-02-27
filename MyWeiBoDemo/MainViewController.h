//
//  MainViewController.h
//  MyWeiBoDemo
//
//  Created by rick on 14-2-26.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoForSina.h"
#import "WeiboCell.h"
#import "Status.h"

@interface MainViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, strong) Status *detailStatus;

- (IBAction)refreshButton:(id)sender;

@property (nonatomic, strong) UIRefreshControl *refreshController;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *array;

@end

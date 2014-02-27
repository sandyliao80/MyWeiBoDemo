//
//  FansViewController.h
//  MyWeiBoDemo
//
//  Created by rick on 14-2-25.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "FansCell.h"

@interface FansViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *followsMutableArray;

@end

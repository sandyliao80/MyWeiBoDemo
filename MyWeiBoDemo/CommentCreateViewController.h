//
//  CommentCreateViewController.h
//  MyWeiBoDemo
//
//  Created by rick on 14-2-26.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoForSina.h"

@interface CommentCreateViewController : UIViewController

- (IBAction)commentButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic, assign) long long weiboID;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;


@end

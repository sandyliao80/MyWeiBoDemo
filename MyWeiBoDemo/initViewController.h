//
//  initViewController.h
//  MyWeiBoDemo
//
//  Created by rick on 14-2-25.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoForSina.h"

@interface initViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

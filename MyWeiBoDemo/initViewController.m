//
//  initViewController.m
//  MyWeiBoDemo
//
//  Created by rick on 14-2-25.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import "initViewController.h"
#import "MBProgressHUD.h"

@interface initViewController ()

@end

@implementation initViewController{
    NSTimer *timer;
    MBProgressHUD *hud;
}

@synthesize imageView = _imageView;
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"view did load");
    
    hud = [[MBProgressHUD alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] == nil) {
        hud.labelText = @"正在授权加载页面中...";
        [hud show:YES];
        [self.view addSubview:hud];
        
        NSString *oauthUrlString = [InfoForSina returnOAuthUrlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:oauthUrlString]];
        [self.webView setDelegate:self];
        [self.webView loadRequest:request];
        _imageView.hidden = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(goWebView) userInfo:nil repeats:NO];
    }else{
        hud.labelText = @"正在加载微博内容...";
        [hud show:YES];
        [self.view addSubview:hud];
        
        
        _imageView.hidden = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(goMainView) userInfo:nil repeats:NO];
    }
    
}

-(void)goWebView{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view cache:YES];
    _imageView.hidden = YES;
    [UIView commitAnimations];
}

-(void)goMainView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:0.8];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    _imageView.hidden = YES;
    [UIView commitAnimations];
    
    [hud removeFromSuperview];
    [self performSegueWithIdentifier:@"MainSegue" sender:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *backUrl = [request URL];
    NSString *backUrlString = [backUrl absoluteString];
    
    if ([backUrlString hasPrefix:@"http://www.baidu.com/?"]) {
        NSRange rangeOne;
        rangeOne = [backUrlString rangeOfString:@"code="];
        NSRange range = NSMakeRange(rangeOne.length + rangeOne.location, backUrlString.length - (rangeOne.length + rangeOne.location));
        
        NSString *codeString = [backUrlString substringWithRange:range];
        
        InfoForSina *infoForSina = [[InfoForSina alloc] init];
        [infoForSina getAccessToken:codeString];
        
        [self performSegueWithIdentifier:@"MainSegue" sender:nil];
        
    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

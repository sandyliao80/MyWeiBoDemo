//
//  CommentCreateViewController.m
//  MyWeiBoDemo
//
//  Created by rick on 14-2-26.
//  Copyright (c) 2014年 rick. All rights reserved.
//

#import "CommentCreateViewController.h"
#define COMMENTCREAT                    @"https://api.weibo.com/2/comments/create.json"

@interface CommentCreateViewController ()

@end

@implementation CommentCreateViewController

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
    self.commentTextView.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_commentTextView becomeFirstResponder];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
}

- (IBAction)commentButton:(id)sender {
    [_commentTextView resignFirstResponder];
    NSString *content = [[NSString alloc] initWithString:_commentTextView.text];
    NSInteger contentLength = content.length;
    
    if (contentLength > 140) {
        MBProgressHUD *overLengthHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:overLengthHud];
        
        overLengthHud.mode = MBProgressHUDModeText;
        overLengthHud.labelText = @"提示信息";
        overLengthHud.detailsLabelText = [NSString stringWithFormat:@"微博字数:%d 超过140上限!", contentLength];
        [overLengthHud show:YES];
        [overLengthHud hide:YES  afterDelay:2];
    }else if(contentLength == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入微博内容!" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        _hud = [[MBProgressHUD alloc] init];
        _hud.dimBackground = YES;
        _hud.labelText = @"正在发送...";
        [_hud show:YES];
        [self.view addSubview:_hud];
        
        
        NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        NSString *paramString = [NSString stringWithFormat:@"comment=%@&id=%lld&access_token=%@", content, _weiboID, accessTokenString];
        
        NSMutableData *postCommentData = [[NSMutableData alloc] init];
        [postCommentData appendData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:COMMENTCREAT] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postCommentData];
        
        NSLog(@"post body = %@", postCommentData);
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.responseData = [[NSMutableData alloc] initWithLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [_hud removeFromSuperview];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    NSString *textString = dict[@"text"];
    NSLog(@"fishloading result = %@",dict);
    if (textString) {
        MBProgressHUD *successHud = [[MBProgressHUD alloc] init];
        successHud.mode = MBProgressHUDModeText;
        successHud.labelText = @"提示";
        successHud.detailsLabelText = @"发表评论成功!";
        [successHud show:YES];
        [self.view addSubview:successHud];
        [successHud hide:YES afterDelay:1.3];
    }else{
        MBProgressHUD *failHud = [[MBProgressHUD alloc] init];
        failHud.mode = MBProgressHUDModeText;
        failHud.labelText = @"提示";
        failHud.detailsLabelText = @"发表评论失败!";
        [failHud show:YES];
        [self.view addSubview:failHud];
        [failHud hide:YES afterDelay:1.3];
    }
    
    [self.connection cancel];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"connection error is %@", error);
    MBProgressHUD *failHud = [[MBProgressHUD alloc] init];
    failHud.mode = MBProgressHUDModeText;
    failHud.labelText = @"提示";
    failHud.detailsLabelText = @"发表评论失败!";
    [failHud show:YES];
    [self.view addSubview:failHud];
    [failHud hide:YES afterDelay:1.3];
    
    [self.connection cancel];
}

@end

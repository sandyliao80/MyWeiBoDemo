//
//  FansCell.m
//  SinaWeiboDemo
//
//  
//

#import "FansCell.h"
#import "MBProgressHUD.h"
#include "AFHTTPClient.h"
#include "AFJSONRequestOperation.h"
//#import "ASIFormDataRequest.h"

@implementation FansCell {
    
    BOOL destroyFriendships;    
    BOOL creatFriendships;

}

@synthesize headImageView = _headImageView;
@synthesize fansButtonLabel = _fansButtonLabel;
@synthesize nameLabel = _nameLabel;
@synthesize fansUIDString = _fansUIDString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)fansButton:(id)sender {
    
    destroyFriendships = NO;
    creatFriendships = NO;
    
    if ([self.fansButtonLabel.titleLabel.text isEqualToString:@"互相关注"]) {
        
        destroyFriendships = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否取消关注" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }

    else if ([self.fansButtonLabel.titleLabel.text isEqualToString:@"+关注"]) {
        creatFriendships = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否关注" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //取消关注
    
    if (destroyFriendships && buttonIndex == 1) {
        
        MBProgressHUD *custuonHUD = [[MBProgressHUD alloc]init];
        custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        custuonHUD.mode = MBProgressHUDModeCustomView;
        [self addSubview:custuonHUD];
        
        NSURL *url = [NSURL URLWithString:BASEURL];
        
        
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [InfoForSina returnAccessTokenString], @"access_token",
                               [NSString stringWithFormat:@"%lld", [_fansUIDString longLongValue]], @"uid",
                               nil
                               ];
        NSLog(@"parma  %@", param);
        [client postPath:@"2/friendships/destroy.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //NSLog(@"success result:%@", responseObject);
            
            [self.fansButtonLabel setTitle:@"+关注" forState:UIControlStateNormal];
            
            custuonHUD.labelText = @"取消关注成功！";
            [custuonHUD show:YES];
            [custuonHUD hide:YES afterDelay:2];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail");
            custuonHUD.labelText = @"取消关注失败！";
            [custuonHUD show:YES];
            [custuonHUD hide:YES afterDelay:2];
        }];
    }
    //添加关注
    
    else if (creatFriendships && buttonIndex == 1) {
        //使用ASI这个类库处理添加关注的数据请求
     
        MBProgressHUD *custuonHUD = [[MBProgressHUD alloc]init];
        custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        custuonHUD.mode = MBProgressHUDModeCustomView;
        [self addSubview:custuonHUD];
       
        
        NSURL *url = [NSURL URLWithString:BASEURL];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [InfoForSina returnAccessTokenString], @"access_token",
                               [NSString stringWithFormat:@"%lld", [_fansUIDString longLongValue]], @"uid",
                               nil
                               ];
        NSLog(@"parma  %@", param);
        [client postPath:@"2/friendships/create.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //NSLog(@"success");
            //NSLog(@"result:%@", responseObject);
            
            [self.fansButtonLabel setTitle:@"互相关注" forState:UIControlStateNormal];
            custuonHUD.labelText = @"关注成功！";
            [custuonHUD show:YES];
            [custuonHUD hide:YES afterDelay:2];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"fail:%@", error);
            custuonHUD.labelText = @"关注失败！";
            [custuonHUD show:YES];
            [custuonHUD hide:YES afterDelay:1];
        }];
        
        /*
        
        //不使用ASI这个类库处理添加关注的数据请求
        NSURL *url = [NSURL URLWithString:FRIENDSHIPS_CREAT];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"access_token=%@&uid=%lld",[InfoForSina returnAccessTokenString],[_fansUIDString longLongValue]];
        NSMutableData *postData = [[NSMutableData alloc] init];
        [postData appendData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postData];
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
         */
    }
    
}

#pragma mark - NSURLConnection delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] initWithLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)theconnection
{
    MBProgressHUD *custuonHUD = [[MBProgressHUD alloc]init];
    custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    custuonHUD.mode = MBProgressHUDModeCustomView;
    [self addSubview:custuonHUD];
    
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    
    NSString *idString = [dict objectForKey:@"idstr"];
    if(idString) {
        [self.fansButtonLabel setTitle:@"互相关注" forState:UIControlStateNormal];
        custuonHUD.labelText = @"关注成功！";
        [custuonHUD show:YES];
        [custuonHUD hide:YES afterDelay:2.3];
    }
    else {
        custuonHUD.labelText = @"关注失败！";
        [custuonHUD show:YES];
        [custuonHUD hide:YES afterDelay:2.3];
    }
    
    [self.connection cancel];
}

-(void)connection:(NSURLConnection *)theconnection didFailWithError:(NSError *)error
{
    MBProgressHUD *failedHud = [[MBProgressHUD alloc] init];
    failedHud.mode = MBProgressHUDModeText;
    failedHud.labelText = @"提示";
    failedHud.detailsLabelText = @"发表评论失败！";
    [failedHud show:YES];
    [self addSubview:failedHud];
    [failedHud hide:YES afterDelay:1.3];
    [self.connection cancel];
}

@end

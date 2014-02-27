//
//  InfoForSina.m
//  SinaWeiboDemo
//
//  Created by 邓 映山 on 13-4-20.
//  Copyright (c) 2013年 Crayon DyS. All rights reserved.
//

#import "InfoForSina.h"
#import "AppDelegate.h"
//#import "JSONKit.h"

@implementation InfoForSina


+ (NSString *) returnAccessTokenString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
}

+ (NSString *) returnOAuthUrlString {
    return [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&state=authorize",OAuth_URL,APP_KEY,APP_REDIRECT_URL];
}

- (void) getAccessToken : (NSString *) code{
    
    //access token调用URL的string
    NSMutableString *accessTokenUrlString = [[NSMutableString alloc] initWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=",ACCESS_TOKEN_URL,APP_KEY,APP_SECRET,APP_REDIRECT_URL];
    [accessTokenUrlString appendString:code];
    
    //同步POST请求
    NSURL *urlstring = [NSURL URLWithString:accessTokenUrlString];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //NSString *backString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    //如何从backString中获取到access_token
    //NSDictionary *dictionary = [backString objectFromJSONString];
    __autoreleasing NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:&error];
  
    [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"access_token"] forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //在获取到access_token之后就获取用户uid
    NSLog(@"access_token = %@", dictionary[@"access_token"]);
    
    [self getUIDString];
}

- (void) getUIDString {
    
    NSString *uidURLString = [[NSString alloc] initWithFormat:@"%@?access_token=%@",GET_UID_URL,[InfoForSina returnAccessTokenString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:uidURLString]];
    NSError *error;
    NSData *uidData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    //NSString *uidString = [[NSString alloc] initWithData:uidData encoding:NSUTF8StringEncoding];
    
    //NSDictionary *uidDictionary = [uidString objectFromJSONString];
    
    __autoreleasing NSError *_error;
    NSDictionary *uidDictionary = [NSJSONSerialization JSONObjectWithData:uidData options:kNilOptions error:&_error];
        
    [[NSUserDefaults standardUserDefaults] setObject:[uidDictionary objectForKey:@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) returnFollowersUrlStringWithCursor:(int)cursor {
    
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    return [NSString stringWithFormat:@"%@?access_token=%@&uid=%lld&cursor=%d",FOLLOWERS_URL,[InfoForSina returnAccessTokenString],[uidString longLongValue],cursor];
    
}

+ (NSString *) returnFriendsTimelintURLString:(int) page {
    return [NSString stringWithFormat:@"%@?access_token=%@&page=%d",FRIENDS_TIMELINE,[InfoForSina returnAccessTokenString],page];
}


+ (NSString *) returnUserTimelineURLString {
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    return [NSString stringWithFormat:@"%@?access_token=%@&id=%@",USERS_TIMELINE,[InfoForSina returnOAuthUrlString],uidString];
}

+ (NSString *)returnCommentUrlStringWithID:(long long)weiboID page:(int)page {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@?access_token=%@&id=%lld&page=%d",COMMENTS,[InfoForSina returnAccessTokenString],weiboID,page];
    return urlString;
}


@end

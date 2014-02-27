//
//  InfoForSina.h
//  SinaWeiboDemo
//
//

#import <Foundation/Foundation.h>
//#import "ASIFormDataRequest.h"
//#import "Status.h"
//#import "JSONKit.h"
#define BASEURL                         @"https://api.weibo.com/"


#define APP_KEY                         @"2473220503"
#define APP_SECRET                      @"9faf8ebe94d285a74a6fcfcc92acfc38"
#define APP_REDIRECT_URL                @"http://www.baidu.com"

#define OAuth_URL                       @"https://api.weibo.com/oauth2/authorize"
#define ACCESS_TOKEN_URL                @"https://api.weibo.com/oauth2/access_token"
#define GET_UID_URL                     @"https://api.weibo.com/2/account/get_uid.json"
#define FOLLOWERS_URL                   @"https://api.weibo.com/2/friendships/followers.json"
#define FRIENDSHIPS_CREAT               @"https://api.weibo.com/2/friendships/create.json"
#define FRIENDSHIPS_DESTROY             @"https://api.weibo.com/2/friendships/destroy.json"
#define FRIENDS_TIMELINE                @"https://api.weibo.com/2/statuses/friends_timeline.json"
#define USERS_TIMELINE                  @"https://api.weibo.com/2/statuses/user_timeline.json"

#define WEIBO_UPDATE                    @"https://api.weibo.com/2/statuses/update.json"//发送文字微博
#define WEIBO_UPLOAD                    @"https://api.weibo.com/2/statuses/upload.json"//发送文字和图片微博

#define COMMENTS                        @"https://api.weibo.com/2/comments/show.json" //评论


//#define 
@interface InfoForSina : NSObject
//返回access token
+ (NSString *) returnAccessTokenString;
//返回获取access token的url
+ (NSString *) returnOAuthUrlString;
//获取access token的方法
- (void) getAccessToken : (NSString *) code; //get access_token
//返回获取粉丝列表的url
+ (NSString *) returnFollowersUrlStringWithCursor:(int)cursor;
 
//加载关注好友微博数据的URL (参数page)
+ (NSString *) returnFriendsTimelintURLString :(int)page;

//返回获取用户自身微博数据的url
+ (NSString *) returnUserTimelineURLString;

//返回评论url
+ (NSString *)returnCommentUrlStringWithID:(long long)weiboID page:(int)page;


@end

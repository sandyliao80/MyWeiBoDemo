//
//  Status.h
//  WeiboPad
//
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Status : NSObject

@property (nonatomic) long long     statusId; //微博ID
@property (nonatomic, strong) NSString*     createdAt;//微博创建时间
@property (nonatomic, strong) NSString*     text; //微博信息内容
@property (nonatomic, strong) NSString*     source; //微博来源
@property (nonatomic, strong) NSString*		sourceUrl;//微博来源Url

@property (nonatomic, assign) BOOL          favorited; //是否已收藏

@property (nonatomic, strong) NSString*		thumbnailPic; //缩略图
@property (nonatomic, strong) NSString*		bmiddlePic; //中型图片
@property (nonatomic, strong) NSString*		originalPic; //原始图片

//@property (nonatomic, retain) User*         user; //作者信息
@property (nonatomic, strong) NSString*     screenName;//作者姓名
@property (nonatomic, strong) NSString*     userHeadImageURL; //作者头像

@property (nonatomic, assign) int           commentsCount; //评论数
@property (nonatomic, assign) int           retweetsCount; // 转发数
@property (nonatomic, retain) Status*       retweetedStatus; //转发的博文，内容为status，如果不是转发，则没有此字段


@property (nonatomic, assign) BOOL          hasRetwitter;
@property (nonatomic, assign) BOOL          haveRetwitterImage;
@property (nonatomic, assign) BOOL          hasImage;

- (Status*)initWithJsonDictionary:(NSDictionary*)dic;

+ (Status*)statusWithJsonDictionary:(NSDictionary*)dic;

@end

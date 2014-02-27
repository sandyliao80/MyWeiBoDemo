//
//  User.h
//  SinaWeiboDemo
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *IDString; //用户的UID : idstr

@property (nonatomic, strong) NSString *nameString; //用户的昵称 : name

@property (nonatomic, strong) NSString *locationString; //用户所在地 : location

@property (nonatomic, strong) NSString *descriptionString; //用户个人描述 : description

@property (nonatomic, strong) NSString *profileImageURL; //用户头像地址，50*50像素

@property (nonatomic, strong) NSString *gender; //性别，m：男、f：女、n：未知  gender

@property (nonatomic) int followersCount; // int	粉丝数 : followers_count

@property (nonatomic) int friendsCount; // int	关注数 : friends_count

@property (nonatomic) int statusesCount; //int 微博数 ： statuses_count

@property (nonatomic) int favouritesCount; //int 收藏数 ：favourites_count

@property (nonatomic) BOOL followMe; //boolean 该用户是否关注当前登录用户，true：是，false：否 follow_me

@property (nonatomic) BOOL following; //我是否关注该粉丝

@property (nonatomic) int onlineStatus; //int	用户的在线状态，0：不在线、1：在线  online_status

- (void) initUserWithDictionary:(NSDictionary *)dictionary;

@end

//
//  User.m
//  SinaWeiboDemo
//
//

#import "User.h"

@implementation User

@synthesize IDString = _IDString;

@synthesize nameString = _nameString;

@synthesize locationString = _locationString;

@synthesize descriptionString = _descriptionString;

@synthesize profileImageURL = _profileImageURL;

@synthesize gender = _gender;

@synthesize followersCount = _followersCount;

@synthesize friendsCount = _friendsCount;

@synthesize statusesCount = _statusesCount;

@synthesize favouritesCount = _favouritesCount;

@synthesize followMe = _followMe;

@synthesize following = _following;

@synthesize onlineStatus = _onlineStatus;

- (void) initUserWithDictionary:(NSDictionary *)dictionary {
    
    _IDString = [dictionary objectForKey:@"idstr"];
    _nameString = [[NSString alloc] initWithString:[dictionary objectForKey:@"name"]];
    _locationString = [dictionary objectForKey:@"location"];
    _descriptionString = [dictionary objectForKey:@"description"];
    _profileImageURL = [[NSString alloc] initWithString:[dictionary objectForKey:@"profile_image_url"]];
    _gender = [dictionary objectForKey:@"gender"];
    _followersCount = [[dictionary objectForKey:@"followers_count"] integerValue];
    _friendsCount = [[dictionary objectForKey:@"friends_count"] integerValue];
    _statusesCount = [[dictionary objectForKey:@"statuses_count"] integerValue];
    _favouritesCount = [[dictionary objectForKey:@"favourites_count"] integerValue];
    //注意：followMe 表示粉丝是否关注了我，这里是粉丝列表，当然是已经关注了我啦
    _followMe = ([dictionary objectForKey:@"follow_me"] == [NSNull null]) ? 0 : [[dictionary objectForKey:@"follow_me"] boolValue];
    //我是否关注了该粉丝
    _following = ([dictionary objectForKey:@"following"] == [NSNull null]) ? 0 : [[dictionary objectForKey:@"following"] boolValue];
    
    _onlineStatus = [[dictionary objectForKey:@"online_status"] integerValue];
}
@end

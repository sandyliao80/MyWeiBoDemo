//
//  WeiboCell.h
//  SinaWeiboDemo
//
//

#import <UIKit/UIKit.h>
#import "Status.h"
@class WeiboCell;

@interface WeiboCell : UITableViewCell 
-(void)setupCell:(Status*)status;

@end

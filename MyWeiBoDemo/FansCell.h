//
//  FansCell.h
//  SinaWeiboDemo
//
//

#import <UIKit/UIKit.h>
#import "InfoForSina.h"

@interface FansCell : UITableViewCell <UIAlertViewDelegate>

- (IBAction)fansButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fansButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) NSString *fansUIDString;//粉丝的UID

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;

@end

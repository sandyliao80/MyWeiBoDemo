//
//  WeiboCell.m
//  SinaWeiboDemo
//
//

#import "WeiboCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation WeiboCell

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 5.0f

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * resultImage = [[UIImage alloc] init];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}

- (NSString *) getTimeString : (NSString *) string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}

-(void)setupCell:(Status*)status {
    
    //使用block设置头像
    __block UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headImageView setFrame:CGRectMake(CELL_CONTENT_MARGIN,CELL_CONTENT_MARGIN, 50, 50)];
    
    CALayer *layer = [headImageView layer];   //设置头像圆角
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:6.0];
    
    
    __block UIImage *headImage = [[UIImage alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        headImage = [self getImageFromURL:status.userHeadImageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [headImageView setImage:headImage];
            [[self contentView] addSubview:headImageView];
        });
    });
    
    //发微博的用户名称
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [userNameLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    
    [[self contentView] addSubview:userNameLabel];

    [userNameLabel setText:status.screenName];
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    [userNameLabel setFrame:CGRectMake(60, 10, 160,28)];
    
    //评论与转发情况
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [commentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE-1]];
    
    [[self contentView] addSubview:commentLabel];
    
    [commentLabel setText:[NSString stringWithFormat:@"评论:%d 转发:%d",status.commentsCount,status.retweetsCount]];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    [commentLabel setTextAlignment:NSTextAlignmentRight];
    [commentLabel setFrame:CGRectMake(220, 13, 100,28)];
    
    //低栏高度设置
    CGFloat yHeight = 0.0;
    
    //设置了微博的内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setNumberOfLines:0];
    [contentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    [[self contentView] addSubview:contentLabel];
    
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
    CGSize size = [status.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setText:status.text];
    [contentLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, headImageView.frame.origin.y + headImageView.frame.size.height + CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height)];
    
    yHeight = contentLabel.frame.origin.y + contentLabel.frame.size.height;
    
    //转发情况
    Status  *retwitterStatus = status.retweetedStatus;
    
    //有转发
    if (status.hasRetwitter && ![retwitterStatus isEqual:[NSNull null]])
    {
        //转发内容的文本内容
        NSString *retwitterContentText = [NSString stringWithFormat:@"%@:%@",retwitterStatus.screenName,retwitterStatus.text];
        UILabel *retwitterContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [retwitterContentLabel setBackgroundColor:[UIColor grayColor]];
        [retwitterContentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [retwitterContentLabel setNumberOfLines:0];
        [retwitterContentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [[self contentView] addSubview:retwitterContentLabel];
        
        CGSize textSize = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
        CGSize size = [retwitterContentText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        [retwitterContentLabel setText:retwitterContentText];
        [retwitterContentLabel setFrame:CGRectMake(6, contentLabel.frame.origin.y + contentLabel.frame.size.height + CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2),size.height)];
        
        yHeight += retwitterContentLabel.frame.size.height;
        
        
        //那么图像就在转发部分进行显示
        if (status.haveRetwitterImage) //转发的微博有图像
        {            
            //设置转发的微博
            __block UIImageView *retwitterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            __block UIImage *retwitterImage = [[UIImage alloc] init];

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                retwitterImage = [self getImageFromURL:status.retweetedStatus.thumbnailPic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    CGSize retwitterImageSize = CGSizeMake(retwitterImage.size.width, retwitterImage.size.height);

                    [retwitterImageView setFrame:CGRectMake((CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN *2) - retwitterImageSize.width)/2, retwitterContentLabel.frame.origin.y + retwitterContentLabel.frame.size.height + CELL_CONTENT_MARGIN, retwitterImageSize.width, retwitterImageSize.height)];
                    
                    [retwitterImageView setImage:retwitterImage];
                    [[self contentView] addSubview:retwitterImageView];
                });
            });
            yHeight +=120;
        }
        
    }
    //无转发
    else
    {
        //微博有图像
        if (status.hasImage) {
            //设置转发的微博
            __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            
            __block UIImage *image = [[UIImage alloc] init];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                image = [self getImageFromURL:status.thumbnailPic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    CGSize imageSize = CGSizeMake(image.size.width, image.size.height);
                    
                    [imageView setFrame:CGRectMake((CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN *2) - imageSize.width)/2, contentLabel.frame.origin.y + contentLabel.frame.size.height + CELL_CONTENT_MARGIN, imageSize.width, imageSize.height)];
                    [imageView setImage:image];
                    [[self contentView] addSubview:imageView];
                });
            });
            yHeight +=120;;
        }
    }
    yHeight += CELL_CONTENT_MARGIN;
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [fromLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [[self contentView] addSubview:fromLabel];
    
    [fromLabel setText:[NSString stringWithFormat:@"来自:%@",status.source]];
    [fromLabel setTextAlignment:NSTextAlignmentLeft];
    fromLabel.adjustsFontSizeToFitWidth = YES;
    [fromLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN,yHeight,140,21)];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [timeLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [[self contentView] addSubview:timeLabel];
    
    [timeLabel setText:[self getTimeString:status.createdAt]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [timeLabel setFrame:CGRectMake(178,yHeight,140,21)];
    
}


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

@end

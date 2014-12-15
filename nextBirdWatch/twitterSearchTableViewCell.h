//
//  twitterSearchTableViewCell.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/24/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface twitterSearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *twitterText;
@property (strong, nonatomic) IBOutlet UILabel *userScreenName;
@property (strong, nonatomic) IBOutlet UIImageView *twitterImage;
@property (strong, nonatomic) IBOutlet UILabel *retweetCount;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;
@property (strong, nonatomic) IBOutlet UILabel *userName;



@end

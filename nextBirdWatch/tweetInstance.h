//
//  tweetInstance.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/20/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface tweetInstance : NSObject

@property (strong, nonatomic) NSString *tweetText;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userScreenName;
@property (strong, nonatomic) NSString *userLocation;
@property (strong, nonatomic) NSNumber *userFavoriteCount;
@property (strong, nonatomic) NSNumber *userRetweetCount;
@property (strong, nonatomic) NSString *userProfileURLImage;
@property (strong, nonatomic) NSString *userTimeOfPost;


@end

//
//  ReturnHomeFromSearchingViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/30/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tweetInstance.h"
#import "RootViewTextFieldContainerView.h"
#import "POP.h"
#import "Canvas.h"
#import "MapButton.h"
#import "RegexButton.h"
#import "SearchBarButton.h"


@interface ReturnHomeFromSearchingViewController : UIViewController

@property (strong, nonatomic) IBOutlet CSAnimationView *nextLogoContainer;
@property (strong, nonatomic) IBOutlet RootViewTextFieldContainerView *searchBar;
@property (strong, nonatomic) IBOutlet UIImageView *nextLogoImage;


@end

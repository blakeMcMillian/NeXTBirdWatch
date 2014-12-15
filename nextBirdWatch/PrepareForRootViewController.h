//
//  PrepareForRootViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/20/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "RootBackgroundView.h"
#import "RootViewTextFieldContainerView.h"

IB_DESIGNABLE
@interface PrepareForRootViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *nextLogoContainer;
@property (strong, nonatomic) IBOutlet UIView *topBar;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;

@end

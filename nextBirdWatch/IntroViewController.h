//
//  IntroViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 12/13/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <pop/POP.h>
#import "RootViewTextFieldContainerView.h"
#import "Canvas.h"

@interface IntroViewController : UIViewController


@property (strong, nonatomic) IBOutlet FLAnimatedImageView *introductionVideo;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (strong, nonatomic) IBOutlet UIView *topBar;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;
- (IBAction)contuineButtonWasPressed:(id)sender;
@property (strong, nonatomic) IBOutlet RootViewTextFieldContainerView *textField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet CSAnimationView *logo;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;


@end

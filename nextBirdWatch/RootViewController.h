//
//  RootViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/20/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitter.h"
#import "tweetInstance.h"
#import "RootViewTextFieldContainerView.h"
#import "POP.h"
#import "Canvas.h"
#import "RegexButton.h"
#import "SearchBarButton.h"
#import "PrepareForSearchGeneralViewController.h"


IB_DESIGNABLE
@interface RootViewController : UIViewController<UITextFieldDelegate, POPAnimationDelegate>

//Interface

//TextField(s)
@property (strong, nonatomic) IBOutlet UITextField *searchBarTextField;

//UIKit Dynamics


//UIView
@property (strong, nonatomic) IBOutlet RootViewTextFieldContainerView *textFieldContainerView;
@property (strong, nonatomic) IBOutlet CSAnimationView *nextAnimationView;



//Gesture Recognizer
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *searchButtonGesture;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *regexButtonGesture;




//UITableViewInstance
@property (strong, nonatomic) IBOutlet UIView *nextLogoEnclosingView;


//UIButton
@property (strong, nonatomic) IBOutlet SearchBarButton *searchButton;
@property (strong, nonatomic) IBOutlet RegexButton *regexButton;


//Programatic

//tweetInstance
@property (strong, nonatomic) tweetInstance *tweet;


//STTwitter
@property (nonatomic, strong) STTwitterAPI *twitter;

//Strings
@property (strong, nonatomic) NSString* contentFromSearchBar;

//NSArray
@property (strong, nonatomic) NSArray* searchResultsFromTwitter;
@property (strong, nonatomic) NSArray* arrayOfTweetsFromTwitterSearch;

//BOOL
@property BOOL didSnapTableViewIntoView;
@property BOOL regexIsEnabled;


//-------------

//IBActions


//Gesture Recognizer
- (IBAction)backgrounViewWasTapped:(id)sender;
- (IBAction)searchButtonWasPressed:(id)sender;
- (IBAction)toggleWasPressed:(id)sender;
- (IBAction)longPressWasDetected:(id)sender;








@end

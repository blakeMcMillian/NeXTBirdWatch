//
//  GeneralSearchViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/29/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPActivityIndicator.h"
#import "RootViewTextFieldContainerView.h"
#import "RootBackgroundView.h"
#import "STTwitter.h"
#import "tweetInstance.h"
#import <pop/POP.h>
#import "twitterSearchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

IB_DESIGNABLE
@interface GeneralSearchViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>


//Interface --------------------------------------------------

//Acitivt Indicator
@property (strong, nonatomic) IBOutlet AMPActivityIndicator *activityIndicator;

//UITextField
@property (strong, nonatomic) IBOutlet UITextField *searchBarTextField;
@property (strong, nonatomic) IBOutlet RootViewTextFieldContainerView *textFieldContainerView;

//TableView
@property (strong, nonatomic) IBOutlet UITableView *tableViewInstance;


//Button
@property (strong, nonatomic) IBOutlet UIButton *homeButton;





//Programetic -------------------------------------------------

//NSInteger
@property int queryCountForRegexSearch;
@property int tweetCountForStreaming;

//NSArray
@property (strong, nonatomic) NSArray* searchResultsFromTwitter;
@property (strong, nonatomic) NSArray* arrayOfTweetsFromTwitterSearch;

//tweetInstance
@property (strong, nonatomic) tweetInstance *tweet;

//STTwitter
@property (nonatomic, strong) STTwitterAPI *twitter;

//BOOL
@property BOOL regexIsEnabled;
@property BOOL didCompleteRegexQuery;

//NSTimer
@property (strong,nonatomic) NSTimer *checkSearhingStatus;

//String
@property (strong, nonatomic) NSString *contentIntextField;


//IBAction
- (IBAction)backgroundWasTapped:(id)sender;
- (IBAction)searchButtonWasPressed:(id)sender;
- (IBAction)homeButtonWasPressed:(id)sender;




@end

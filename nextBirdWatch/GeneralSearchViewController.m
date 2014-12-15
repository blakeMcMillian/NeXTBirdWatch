//
//  GeneralSearchViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/29/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "GeneralSearchViewController.h"
#import "Regexer.h"

@interface GeneralSearchViewController ()

@end

@implementation GeneralSearchViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;

}//end - preferredStatusBarStyle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.queryCountForRegexSearch = 20;
    self.tweetCountForStreaming = 2000;
    self.tableViewInstance.estimatedRowHeight = 89;
    self.tableViewInstance.rowHeight = UITableViewAutomaticDimension;
    
    
    //Setting up the view
    [self initTextFieldWithContentAndProperties];
    [self settingUpTwitterConfig];
    [self performTwitterSearchOperation];
    [self performSelector:@selector(pushTextField) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(presentHomeButton) withObject:nil afterDelay:2.0];
    //remove the activity indicator from the view
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
     [self startActivityIndicator];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma setupMethods
-(void)performTwitterSearchOperation
{
    //Checking if REGEX search, is enabled
    if (self.regexIsEnabled)                //(REGEX SEARCH)
    {
        [self performSelectorOnMainThread:@selector(getStreamingResultsFromTwitter) withObject:nil waitUntilDone:YES];
        
    }//end if - statement                   //(GENERAL SEARCH)
    else
    {
        //performing the searchs on the main thread
        [self performSelectorOnMainThread:@selector(getSearchResultsFromTwitter) withObject:nil waitUntilDone:YES];
        
        
    }//end - else statement
    
    //wait until the data from Twitter has loaded
    [self didLoadSearchResults];
 
}

-(void)didLoadSearchResults // Change the valid count based on the Twitter results
{
    int validCountForPresentingTableView = 0;
    
    if (self.regexIsEnabled)
    {
        validCountForPresentingTableView = self.queryCountForRegexSearch;
    }
    
    if ([self.searchResultsFromTwitter count] > validCountForPresentingTableView || self.didCompleteRegexQuery == YES)
    {

        //performing the searchs on the main thread
        [self performSelectorOnMainThread:@selector(parsingSearchResultsFromTwitter) withObject:nil waitUntilDone:YES];
        
        //waiting for the tweets to be parsed
        [self didParseTweetsFromSearchResults];
        
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(didLoadSearchResults)
                                       userInfo:nil
                                        repeats:NO];
    }
    
}

-(void)didParseTweetsFromSearchResults
{
    int validCountForPresentingTableView = 0;
    
    if (self.regexIsEnabled)
    {
        validCountForPresentingTableView = self.queryCountForRegexSearch;
    }
    
    if (([self.arrayOfTweetsFromTwitterSearch count] > validCountForPresentingTableView) || self.didCompleteRegexQuery == YES)
    {
        
        //fading the activity indicator
        [self fadeActivityIndicator];
        
        [self.tableViewInstance reloadData];
        
        //Presenting the tableview into the view
        [self presentTableView];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(didParseTweetsFromSearchResults)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    
}

-(void)settingUpTwitterConfig
{
    //authenticating the user's information
    [self verifyTwitterAuthenticationData];
    [self performSelectorOnMainThread:@selector(performTwitterSearchOperation) withObject:nil waitUntilDone:YES];
    
}//end settingUpElementsInView

#pragma mark - Initalizations
-(void)initTextFieldWithContentAndProperties
{
    //Do something ...
    
    self.searchBarTextField.text = self.contentIntextField;
    self.searchBarTextField.textColor = [UIColor whiteColor];
    self.searchBarTextField.textAlignment = NSTextAlignmentLeft;
}


#pragma mark - Animations
-(void)startActivityIndicator
{
    [self.activityIndicator setBarColor:[UIColor greenColor]];
    [self.activityIndicator setBarHeight:10.0];
    [self.activityIndicator setBarWidth:50.0];
    [self.activityIndicator setAperture:60.0];
    
    [self.activityIndicator startAnimating];
}

-(void)fadeActivityIndicator
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.activityIndicator pop_addAnimation:anim forKey:@"activityViewFadeAniamtion"];
}

-(void)fadeSearchBarTextField
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.searchBarTextField pop_addAnimation:anim forKey:@"searchBartextFieldAnimation"];
}

-(void)fadeHomeButton
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.homeButton pop_addAnimation:anim forKey:@"homeButtonFadeAnimation"];
}

-(void)presentActivityIndicator
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.activityIndicator pop_addAnimation:anim forKey:@"activityViewPresentAniamtion"];
}


-(void)presentTableView
{
    //reloading the data in the tableview
    [self.tableViewInstance reloadData];
    
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.tableViewInstance pop_addAnimation:anim forKey:@"presentTableViewAniamtion"];
   
}

-(void)hideTableView
{
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.tableViewInstance pop_addAnimation:anim forKey:@"hideTableViewAniamtion"];
    
}

-(void)pushTextField
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(188, 28.5, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"SearchBarTextField";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 3;
    basicAnimation.springSpeed = 10;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.searchBarTextField pop_addAnimation:basicAnimation forKey:@"AnimateSearchBarTextField"];
}

-(void)retractTextField
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(139, 28.5, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"SearchBarTextField";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 3;
    basicAnimation.springSpeed = 10;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.searchBarTextField pop_addAnimation:basicAnimation forKey:@"AnimateSearchBarTextField"];
}

-(void)presentHomeButton
{
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.homeButton pop_addAnimation:anim forKey:@"fadeHomeButton"];
    
}

#pragma mark - TextField Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
 
    //Do something ...
    self.searchBarTextField.textColor = [UIColor whiteColor];
    self.searchBarTextField.textAlignment = NSTextAlignmentLeft;
    
    //Highlighting the text field upon selection
    self.textFieldContainerView.textFieldSelectionStatus = YES;
    [self.textFieldContainerView setNeedsDisplay];
    
}//end textFieldDidBeginEditing

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Store the variables
    self.contentIntextField =  self.searchBarTextField.text;
    
    //UN -Highlighting the text field upon DR-selection
    self.textFieldContainerView.textFieldSelectionStatus = NO;
    [self.textFieldContainerView setNeedsDisplay];
    
}//end textFieldDidEndEditing

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //closing the keyboard
    [textField resignFirstResponder];
    
    return YES;
}//end textFieldShouldReturn


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions
- (IBAction)backgroundWasTapped:(id)sender
{
     [self.searchBarTextField resignFirstResponder];
}

- (IBAction)searchButtonWasPressed:(id)sender
{
    //hiding the tableview controller
    [self hideTableView];
    
    //presenting the activity indicator
    [self presentActivityIndicator];
    
    //Resetting the twitter Array's
    self.arrayOfTweetsFromTwitterSearch = [[NSArray alloc]init];
    self.searchResultsFromTwitter = [[NSArray alloc] init];
    
    //Removing the keyboard from the screen
    [self.searchBarTextField resignFirstResponder];
    
    //resetting the boolean
    self.didCompleteRegexQuery = NO;
    
    //performing the Twitter Searching Operation
    [self performTwitterSearchOperation];
    
}

- (IBAction)homeButtonWasPressed:(id)sender
{
    self.homeButton.userInteractionEnabled = NO;
    
    [self performSelector:@selector(fadeHomeButton) withObject:nil afterDelay:.1];
    [self performSelector:@selector(fadeSearchBarTextField) withObject:nil afterDelay:.1];
    
    if (self.activityIndicator.alpha != 0)
    {
        [self performSelector:@selector(fadeActivityIndicator) withObject:nil afterDelay:.1];
    }
    [self performSelector:@selector(hideTableView) withObject:nil afterDelay:.1];
    [self performSelector:@selector(performSegueToDestinationViewController) withObject:nil afterDelay:.5];
    
}

-(void)performSegueToDestinationViewController
{
    [self performSegueWithIdentifier:@"segueToHomeAnimationView" sender:self];
}

#pragma popUp
-(void) presentStockPopupToUserwithTitle: (NSString *)popUpTitle andMessage:(NSString *)popUpMessage
{
    //Alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:popUpTitle
                                                    message:popUpMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}//end presentStockPopupToUser


#pragma Twitter Methods

-(void)verifyTwitterAuthenticationData
{
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         NSLog(@"Authentication = Success !");
         
     } errorBlock:^(NSError *error)
     {
         //Alert
         [self presentStockPopupToUserwithTitle:@"Authentication Error"
                                     andMessage:@"Please visit settings. Could not authenticate this iPhone !"];
         
     }];
    
}//end - verifyTwitterAuthenticationData

-(void)getSearchResultsFromTwitter
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         [twitter getSearchTweetsWithQuery:self.contentIntextField geocode:@"" lang:@"" locale:@"" resultType:@"recent" count:@"100" until:@"" sinceID:@"" maxID:@"" includeEntities:@(0) callback:@"" successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
             
             NSLog(@"searchMetadata = %@", searchMetadata);
             NSLog(@"statuses = %@", statuses);
             
             //Storing the search results from Twitter
             self.searchResultsFromTwitter = [[NSArray alloc]initWithArray:statuses copyItems:YES];
             
         } errorBlock:^(NSError *error)
          {
              NSLog(@"twitter error = %@", error);
              
          }];//end - error Block
         
     } errorBlock:^(NSError *error)
     {
         NSLog(@"-- error %@", error);
     }];
    
}//end - getSearchResultsFromTwitter

-(void)getStreamingResultsFromTwitter
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         NSMutableArray *data = [NSMutableArray array];
         NSMutableArray *dataWithCorrectMath = [NSMutableArray array];

         
         __block id twitterRequest = [twitter postStatusesFilterUserIDs:nil
                                                        keywordsToTrack:nil
                                                  locationBoundingBoxes:@[@"-180",@"-90",@"180",@"90"]
                                                              delimited:@20
                                                          stallWarnings:nil
                                                          progressBlock:^(NSDictionary *tweet)
         {
                                                              
                NSLog(@"-- data count: %lu", (unsigned long)[data count]);
                                                              
                                                              if (([data count] >= self.tweetCountForStreaming) || ([self.searchResultsFromTwitter count] == self.queryCountForRegexSearch))
                                                              {
                                                                  NSLog(@"-- cancel");
                                                                  self.didCompleteRegexQuery = YES;
                                                                  [twitterRequest cancel];
                                                              }
                                                              else
                                                              {
                                                                  //Lightly parsing the regular expression
                                                                  NSString * regex = self.contentIntextField;
                                                                  
                                                                  regex = [regex stringByReplacingOccurrencesOfString:@"\""
                                                                                                           withString:@"\\\""];
                                                                  
                                                                  BOOL match = [[tweet valueForKey:@"text"] rx_matchesPattern:regex options:NSRegularExpressionAllowCommentsAndWhitespace];
                                                                  
                                                                  
                                                                  
                                                                  //adding the item to data
                                                                  [data addObject:tweet];
                                                                  if (match)
                                                                  {
                                                                      [dataWithCorrectMath addObject:tweet];
                                                                      
                                                                      //Storing the search results from Twitter
                                                                      self.searchResultsFromTwitter = [[NSArray alloc]initWithArray:dataWithCorrectMath copyItems:YES];
                                                                  
                                                                  }//end - if statement
                                                                  
                                                                  
                                                                   NSLog(@"%@",[tweet valueForKey:@"text"]);
                                                              }
             
             
                                                          } stallWarningBlock:nil
                                                             errorBlock:^(NSError *error) {
                                                                 NSLog(@"-- error 2: %@", error);
                                                             }];
         
     } errorBlock:^(NSError *error)
     {
         NSLog(@"-- error %@", error);
     }];
    
}

#pragma Parsing data from twitter
-(void)parsingSearchResultsFromTwitter
{
    //Attributes
    NSMutableArray* tempMutableArrayOfTweetsFromTwitterSearch = [[NSMutableArray alloc]init];
    
    //Iterating over the array of user status Dictionaries
    for (NSDictionary* userStatus in self.searchResultsFromTwitter)
    {
        //Populating the tweetINstance Object
        
        //Creating a new tweet object
        self.tweet = [[tweetInstance alloc] init];
        
        self.tweet.tweetText = [userStatus valueForKey:@"text"];
        self.tweet.userName =  [[userStatus objectForKey:@"user"] objectForKey:@"name"];
        self.tweet.userFavoriteCount = [userStatus valueForKey:@"favorite_count"];
        self.tweet.userRetweetCount = [userStatus valueForKey:@"retweet_count"];
        self.tweet.userProfileURLImage =  [[userStatus objectForKey:@"user"] objectForKey:@"profile_image_url"];
        self.tweet.userScreenName =  [[userStatus objectForKey:@"user"] objectForKey:@"screen_name"];
        
        
        //Printing the tweet string
        NSLog(@"%@: %@", self.tweet.userName,self.tweet.tweetText);
        
        //Storing the tweets into an array
        [tempMutableArrayOfTweetsFromTwitterSearch addObject:self.tweet];
        
        [self.tableViewInstance reloadData];
        
    }//end for - in loop
    
    //initalizing the tweetsFromSearchResults array with tweet
    self.arrayOfTweetsFromTwitterSearch = [[NSArray alloc] initWithArray:tempMutableArrayOfTweetsFromTwitterSearch];
    
}//end - parsing search reuslts from twitter


#pragma mark TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResultsFromTwitter count];    //count number of row from counting array hear cataGorry is An Array
}




- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    twitterSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[twitterSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
    }//end if statement
    
    //Creating a temporary twitter object instance
    tweetInstance *tweet = [[tweetInstance alloc]init];
    
    tweet = [self.arrayOfTweetsFromTwitterSearch objectAtIndex:indexPath.row];
    
    cell.twitterText.text = tweet.tweetText;
    NSString *myString = @"@";
    NSString *formattedString = [myString stringByAppendingString:tweet.userScreenName];
    cell.userName.text = formattedString;
    cell.userScreenName.text = tweet.userName;
    cell.retweetCount.text = [tweet.userRetweetCount stringValue];
    cell.favoriteCount.text = [tweet.userFavoriteCount stringValue];
    [cell.twitterImage setImageWithURL:tweet.userProfileURLImage
                      placeholderImage:[UIImage imageNamed:@"twitterLogo.png"]];
    

    return cell;
}
@end

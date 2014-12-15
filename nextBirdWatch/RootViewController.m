//
//  RootViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/20/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}//end - preferredStatusBarStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //setup
    [self settingUpTwitterConfig];
    [self setupElementInView];

    
}//end - viewDidLoad

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma setupMethods
-(void)settingUpTwitterConfig
{
    //authenticating the user's information
    [self verifyTwitterAuthenticationData];
    
}//end settingUpElementsInView

-(void)setupElementInView
{
    
}//end - setupElementInView



#pragma mark - TextField Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //ANIMATION
    [self presentButtonsWhenKeyboardIsSelected];

    
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
     self.contentFromSearchBar =  self.searchBarTextField.text;
    [self hideButtonsWhenKeyboardIsDeSelected];
    
    //UN -Highlighting the text field upon DR-selection
    self.textFieldContainerView.textFieldSelectionStatus = NO;
    [self.textFieldContainerView setNeedsDisplay];
    
}//end textFieldDidEndEditing

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //closing the keyboard
    [textField resignFirstResponder];
    [self hideButtonsWhenKeyboardIsDeSelected];
    
    return YES;
}//end textFieldShouldReturn

#pragma mark POP Button Animations
-(void)presentButtonsWhenKeyboardIsSelected
{
    [self performSelector:@selector(fadeRegexButton) withObject:nil afterDelay:.1];
    [self performSelector:@selector(fadeSearchButton) withObject:nil afterDelay:.1];
    
    
}//end - presentTheButtonsIntoView

-(void)hideButtonsWhenKeyboardIsDeSelected
{
    [self performSelector:@selector(presentSearchButton) withObject:nil afterDelay:.1];
    [self performSelector:@selector(presentRegexButton) withObject:nil afterDelay:.1];
    
}

-(void)presentSearchButton
{
    POPBasicAnimation *basicAnimation= [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.fromValue = @(1);
    basicAnimation.toValue= @(0); // scale from 0 to 1
    basicAnimation.delegate=self;
    [self.searchButton pop_addAnimation:basicAnimation forKey:@"AnimateSearchButton"];
}

-(void)presentRegexButton
{
    POPBasicAnimation *basicAnimation= [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.fromValue = @(1);
    basicAnimation.toValue= @(0); // scale from 0 to 1
    basicAnimation.delegate=self;
    [self.regexButton pop_addAnimation:basicAnimation forKey:@"AnimateRegexButton"];
}

-(void)fadeSearchButton
{
    POPBasicAnimation *basicAnimation= [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue= @(1); // scale from 0 to 1
    basicAnimation.delegate=self;
    [self.searchButton pop_addAnimation:basicAnimation forKey:@"fadeSearchButton"];
}

-(void)fadeRegexButton
{
    POPBasicAnimation *basicAnimation= [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue= @(1); // scale from 0 to 1
    basicAnimation.delegate=self;
    [self.regexButton pop_addAnimation:basicAnimation forKey:@"fadeRegexButton"];
}

#pragma mark Animations
-(void)performPopAnimation
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(0); // scale from 0 to 1
    
}//end - performPopAnimation

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
     if ([[segue identifier] isEqualToString: @"segueToPrepForGeneralSearchViewController"])
    {
        PrepareForSearchGeneralViewController *vc = (PrepareForSearchGeneralViewController*)[segue destinationViewController];
       
        
        //Setting the parameters in future views
        vc.contentInTextField = self.contentFromSearchBar;
        vc.regexIsEnabled = self.regexIsEnabled;
    
    }
    
    
}


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
         [twitter getSearchTweetsWithQuery:self.contentFromSearchBar geocode:@"" lang:@"" locale:@"" resultType:@"recent" count:@"100" until:@"" sinceID:@"" maxID:@"" includeEntities:@(0) callback:@"" successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {

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


        //Printing the tweet string
        NSLog(@"%@: %@", self.tweet.userName,self.tweet.tweetText);

        //Storing the tweets into an array
        [tempMutableArrayOfTweetsFromTwitterSearch addObject:self.tweet];
        //
        //        //relaoding the tableview data
        //        [self.tableViewInstance reloadData];

    }//end for - in loop

    //initalizing the tweetsFromSearchResults array with tweet
    self.arrayOfTweetsFromTwitterSearch = [[NSArray alloc] initWithArray:tempMutableArrayOfTweetsFromTwitterSearch];

}//end - parsing search reuslts from twitter


-(void)loadViewTwitterDataBeforeSegue
{
    
    //Close the search Bar
    [self.searchBarTextField resignFirstResponder];
    
    //Perform View segue
//    [self performSelector:@selector(getSearchResultsFromTwitter) withObject:nil afterDelay:0];
//    [self performSelector:@selector(parsingSearchResultsFromTwitter) withObject:nil afterDelay:4];
    [self performSelector:@selector(segueToDestinationController) withObject:nil afterDelay:.1];
    
    
}//end - loadTwitterDataBeforeSegue

-(void)segueToDestinationController
{
    
    if (self.searchButton.buttonWasPressed == YES || self.regexButton.buttonWasPressed == YES)
    {
        [self performSegueWithIdentifier:@"segueToPrepForGeneralSearchViewController" sender:self];
    }
    else{
        [self presentStockPopupToUserwithTitle:@"Invalid Search" andMessage:@"Please toggle a valid query parameter!"];
    }
    

    
}//end - segue


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


- (IBAction)backgrounViewWasTapped:(id)sender
{
    [self.searchBarTextField resignFirstResponder];
    
}

- (IBAction)searchButtonWasPressed:(id)sender
{
    [self loadViewTwitterDataBeforeSegue];
}

- (IBAction)toggleWasPressed:(id)sender
{
    
    if (sender == self.searchButtonGesture)
    {
        //Toggling the button and resetting the rest
        [self.searchButton toggleButton];
        self.regexButton.buttonWasPressed = NO;
        
        //Confriming that REGEX is  NOT enabled
        self.regexIsEnabled = NO;
        
        //Forcing the buttons to be redisplayed
        [self.searchButton setNeedsDisplay];
        [self.regexButton setNeedsDisplay];
    }
    else if (sender == self.regexButtonGesture)
    {
        //Confriming that REGEX is enabled
        self.regexIsEnabled = YES;
        
        //Toggling the button and resetting the rest
        [self.regexButton toggleButton];
        self.searchButton.buttonWasPressed = NO;
        
        //Forcing the buttons to be redisplayed
        [self.searchButton setNeedsDisplay];
        [self.regexButton setNeedsDisplay];
    }
    
    
}

- (IBAction)longPressWasDetected:(id)sender
{
    [self performSegueWithIdentifier:@"segueToPreMapView" sender:self];
}


@end

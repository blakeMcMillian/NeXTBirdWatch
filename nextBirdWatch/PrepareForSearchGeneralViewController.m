//
//  PrepareForSearchGeneralViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/29/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "PrepareForSearchGeneralViewController.h"

@interface PrepareForSearchGeneralViewController ()

@end

@implementation PrepareForSearchGeneralViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}//end - preferredStatusBarStyle


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setting up the textfield
    [self initTextFieldWithContentAndProperties];
    [self animateElementsInView];
}

-(void)initTextFieldWithContentAndProperties
{
    //Do something ...
    
    self.searchBarTextField.text = self.contentInTextField;
    self.searchBarTextField.textColor = [UIColor whiteColor];
    self.searchBarTextField.textAlignment = NSTextAlignmentLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animateElementsInView
{
    //Aniamting elements
    [self performSelector:@selector(fadeNextLogo) withObject:nil afterDelay:.3];
    [self performSelector:@selector(animateSearchBar) withObject:nil afterDelay:.8];
    [self performSelector:@selector(segueToGeneralSearchingView) withObject:nil afterDelay:1.3];
}

-(void)fadeNextLogo
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.nextLogo pop_addAnimation:anim forKey:@"fade"];
}

-(void)animateSearchBar
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(209, 63, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"SearchBar";
    basicAnimation.delegate=self;
 //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 3;
    basicAnimation.springSpeed = 10;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.searchBar pop_addAnimation:basicAnimation forKey:@"AnimateSearchBar"];
}

-(void)segueToGeneralSearchingView
{
    [self performSegueWithIdentifier:@"segueToGeneralSearchView" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString: @"segueToGeneralSearchView"])
    {
        GeneralSearchViewController*vc = (GeneralSearchViewController*)[segue destinationViewController];
        
        vc.contentIntextField = self.contentInTextField;
        //Setting the Parameters for future views
        vc.regexIsEnabled = self.regexIsEnabled;
    }
}


@end

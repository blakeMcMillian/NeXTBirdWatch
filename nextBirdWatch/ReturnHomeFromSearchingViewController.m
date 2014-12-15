//
//  ReturnHomeFromSearchingViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/30/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "ReturnHomeFromSearchingViewController.h"

@interface ReturnHomeFromSearchingViewController ()

@end

@implementation ReturnHomeFromSearchingViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}//end - preferredStatusBarStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self animateElementsInView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(presentRootViewController) withObject:nil afterDelay:2.0];
    
}

-(void)animateElementsInView
{
    
    [self performSelector:@selector(animateSearchBar) withObject:nil afterDelay:.5];
    [self performSelector:@selector(presentNextLogo) withObject:nil afterDelay:1.0];
    
}

-(void)presentNextLogo
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.nextLogoImage pop_addAnimation:anim forKey:@"fade"];
    
}

-(void)animateSearchBar
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(209, 359, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"SearchBar";
    basicAnimation.delegate=self;
    basicAnimation.springBounciness = 0;
    basicAnimation.springSpeed = 5;

    [self.searchBar pop_addAnimation:basicAnimation forKey:@"animateSearchBar"];
    
}//end






-(void)presentRootViewController
{
    [self performSegueWithIdentifier:@"segueBackToHomeViewFromGeneralSearchingView" sender:self];
    
}//end - presentRootViewController




@end

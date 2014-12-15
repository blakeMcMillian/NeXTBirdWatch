//
//  PreMapViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 12/13/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "PreMapViewController.h"

@interface PreMapViewController ()

@end

@implementation PreMapViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}//end - preferredStatusBarStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(animateNextLogo) withObject:nil afterDelay:.3];
    [self performSelector:@selector(animateSearchBar) withObject:nil afterDelay:.8];
    [self performSelector:@selector(presentRootViewController) withObject:nil afterDelay:1.3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animateNextLogo
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(0);
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"AnimateNextLogo";
    basicAnimation.delegate=self;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.nextLogoContainer pop_addAnimation:basicAnimation forKey:@"AnimateNextLogo"];
    
}

-(void)animateSearchBar
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(209, 778, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"SearchBar";
    basicAnimation.delegate=self;
    basicAnimation.springBounciness = 10;
    basicAnimation.springSpeed = 3;
    
    [self.containerView pop_addAnimation:basicAnimation forKey:@"animateSearchBar"];
    
}//end


-(void)presentRootViewController
{
    self.containerView.hidden = YES;
    self.nextLogoContainer.hidden = YES;
    [self performSegueWithIdentifier:@"segueToMapView" sender:self];
    
}//end - presentRootViewController

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

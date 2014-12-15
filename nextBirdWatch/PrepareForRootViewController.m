//
//  PrepareForRootViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/20/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "PrepareForRootViewController.h"

@interface PrepareForRootViewController ()

@end

@implementation PrepareForRootViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self performSelector:@selector(animateNextLogo) withObject:nil afterDelay:1.0];
     [self performSelector:@selector(presentTopBar) withObject:nil afterDelay:1.3];
     [self performSelector:@selector(presentBottomBar) withObject:nil afterDelay:1.3];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}//end - preferredStatusBarStyle


-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(presentRootViewController) withObject:nil afterDelay:2.0];
    
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

-(void)presentTopBar
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 94, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"animateTopBar";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 0;
    basicAnimation.springSpeed = 20;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.topBar pop_addAnimation:basicAnimation forKey:@"animateTopBar"];
}


-(void)presentBottomBar
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 661, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"animateBottomBar";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 0;
    basicAnimation.springSpeed = 20;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.bottomBar pop_addAnimation:basicAnimation forKey:@"animateBottomBar"];
}

-(void)presentRootViewController
{
    [self performSegueWithIdentifier:@"presentIntroView" sender:self];
    
}//end - presentRootViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end

//
//  IntroViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 12/13/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FLAnimatedImage *intro = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NeXT" ofType:@"gif"]]];
    
    self.introductionVideo.animatedImage = intro;
    [self performSelector:@selector(hideVideoView) withObject:nil afterDelay:33];
    [self performSelector:@selector(hideBottomBar) withObject:nil afterDelay:34];
    [self performSelector:@selector(hideTopBar) withObject:nil afterDelay:34];
    [self performSelector:@selector(presentSearchBar) withObject:nil afterDelay:36];
    [self performSelector:@selector(presentSearchButton) withObject:nil afterDelay:36];
    [self performSelector:@selector(presentNextLogo) withObject:nil afterDelay:36];
    [self performSelector:@selector(presentRootViewController) withObject:nil afterDelay:37];

    }//end - view did load


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self performSelector:@selector(presentVideoView) withObject:nil afterDelay:.1];
    [self performSelector:@selector(presentBlur) withObject:nil afterDelay:3.0];
}

-(void)presentVideoView
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(1);
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"animateVideo";
    basicAnimation.delegate=self;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.introductionVideo pop_addAnimation:basicAnimation forKey:@"animateVideo"];
}

-(void)presentNextLogo
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(1);
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"logo";
    basicAnimation.delegate=self;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.logoImage pop_addAnimation:basicAnimation forKey:@"logo"];
}

-(void)presentSearchBar
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(1);
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"text";
    basicAnimation.delegate=self;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.textField pop_addAnimation:basicAnimation forKey:@"text"];
}

-(void)presentSearchButton
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(1);
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"bar";
    basicAnimation.delegate=self;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.searchButton pop_addAnimation:basicAnimation forKey:@"bar"];
}

-(void)hideTopBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    [self setNeedsStatusBarAppearanceUpdate];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, -74, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"topBar";
    basicAnimation.delegate=self;
    basicAnimation.springBounciness = 0;
    basicAnimation.springSpeed = 1;
    
    [self.topBar pop_addAnimation:basicAnimation forKey:@"topBar"];
    
    
}

-(void)hideBottomBar
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 814, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"bottomBar";
    basicAnimation.delegate=self;
    basicAnimation.springBounciness = 1;
    basicAnimation.springSpeed = 1;
    
    [self.bottomBar pop_addAnimation:basicAnimation forKey:@"bottomBar"];
    
    
}

-(void)hideVideoView
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.toValue= @(0);
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"animateHVideo";
    basicAnimation.delegate=self;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.introductionVideo pop_addAnimation:basicAnimation forKey:@"animateHVideo"];
}

-(void)presentBlur
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 705, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"blurView";
    basicAnimation.delegate=self;
    basicAnimation.springBounciness = 1;
    basicAnimation.springSpeed = 1;
    
    [self.blurView pop_addAnimation:basicAnimation forKey:@"blueView"];
}//end blur view

-(void)presentRootViewController
{
    //fromIntoToRootView
    [self performSegueWithIdentifier:@"fromIntoToRootView" sender:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)contuineButtonWasPressed:(id)sender
{
    
    [self performSelector:@selector(hideVideoView) withObject:nil afterDelay:1];
    [self performSelector:@selector(hideBottomBar) withObject:nil afterDelay:2];
    [self performSelector:@selector(hideTopBar) withObject:nil afterDelay:2];
    [self performSelector:@selector(presentSearchBar) withObject:nil afterDelay:3];
    [self performSelector:@selector(presentSearchButton) withObject:nil afterDelay:3];
    [self performSelector:@selector(presentNextLogo) withObject:nil afterDelay:3];
    [self performSelector:@selector(presentRootViewController) withObject:nil afterDelay:4];
    
}
@end

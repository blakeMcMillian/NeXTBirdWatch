//
//  PrepareForSearchGeneralViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/29/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"
#import "RootViewTextFieldContainerView.h"
#import <pop/POP.h>
#import "AMPActivityIndicator.h"
#import "GeneralSearchViewController.h"

IB_DESIGNABLE
@interface PrepareForSearchGeneralViewController : UIViewController

//UIView
@property (strong, nonatomic) IBOutlet UIImageView *nextLogo;

@property (strong, nonatomic) IBOutlet RootViewTextFieldContainerView *searchBar;
@property (strong, nonatomic) IBOutlet UITextField *searchBarTextField;
@property (strong, nonatomic) NSString *contentInTextField;


//Programetic

//BOOL
@property BOOL regexIsEnabled;

@end

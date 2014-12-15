//
//  RegexButton.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/27/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface RegexButton : UIButton


@property BOOL buttonWasPressed;
-(void)toggleButton;

@end

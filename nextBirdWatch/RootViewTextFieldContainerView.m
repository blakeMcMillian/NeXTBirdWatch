//
//  RootViewTextFieldContainerView.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/22/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "RootViewTextFieldContainerView.h"
#import "NextBirdWatchStyleKit.h"

@implementation RootViewTextFieldContainerView


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [NextBirdWatchStyleKit drawRootViewTextFieldContainerWithTextFieldWasSelected:self.textFieldSelectionStatus];
}


@end

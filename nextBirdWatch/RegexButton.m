//
//  RegexButton.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/27/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "RegexButton.h"
#import "NextBirdWatchStyleKit.h"

@implementation RegexButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [NextBirdWatchStyleKit drawRegexSearchButtonCanvasImageWithRegexButtonWasPressed:self.buttonWasPressed];
}

-(void)toggleButton
{
    if (self.buttonWasPressed)
    {
        self.buttonWasPressed = NO;
    }
    else
        self.buttonWasPressed = YES;
    
    [self setNeedsDisplay];
}


@end

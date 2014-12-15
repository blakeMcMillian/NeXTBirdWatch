//
//  SearchBarButton.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/26/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "SearchBarButton.h"
#import "NextBirdWatchStyleKit.h"

@implementation SearchBarButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [NextBirdWatchStyleKit drawSearchButtonCanvasImageWithSearchButtonWasPressed:self.buttonWasPressed];
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

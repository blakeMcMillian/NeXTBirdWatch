//
//  MapButton.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/27/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "MapButton.h"
#import "NextBirdWatchStyleKit.h"

@implementation MapButton

//Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [NextBirdWatchStyleKit drawMapButtonCanvasImageWithMapButtonWasPressed:self.buttonWasPressed];

}//end


-(void)toggleButton
{
    if (self.buttonWasPressed)
    {
        self.buttonWasPressed = NO;
    }
    else
        self.buttonWasPressed = YES;
    
    [self setNeedsDisplay];
}//end function


@end

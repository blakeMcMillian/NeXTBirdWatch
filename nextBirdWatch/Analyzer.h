//
//  Analyzer.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 12/15/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTwitter.h"
#import "tweetInstance.h"
#import "Regexer.h"

@interface Analyzer : NSObject

//Testing Testing


//tweetInstance
@property (strong, nonatomic) tweetInstance *tweet;

//STTwitter
@property (nonatomic, strong) STTwitterAPI *twitter;

//NSArray
@property (strong, nonatomic) NSArray* searchResultsFromTwitter;
@property (strong, nonatomic) NSArray* arrayOfTweetsFromTwitterSearch;

//NSInteger
@property int queryCountForRegexSearch;
@property int tweetCountForStreaming;

//BOOL
@property BOOL regexIsEnabled;
@property BOOL didCompleteRegexQuery;

@end

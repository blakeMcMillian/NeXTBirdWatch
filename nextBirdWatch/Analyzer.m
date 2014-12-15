//
//  Analyzer.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 12/15/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "Analyzer.h"

@implementation Analyzer


-(void)getSearchResultsFromTwitter
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         [twitter getSearchTweetsWithQuery:@"" geocode:@"" lang:@"" locale:@"" resultType:@"recent" count:@"100" until:@"" sinceID:@"" maxID:@"" includeEntities:@(0) callback:@"" successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
             
             NSLog(@"searchMetadata = %@", searchMetadata);
             NSLog(@"statuses = %@", statuses);
             
             //Storing the search results from Twitter
             self.searchResultsFromTwitter = [[NSArray alloc]initWithArray:statuses copyItems:YES];
             
         } errorBlock:^(NSError *error)
          {
              NSLog(@"twitter error = %@", error);
              
          }];//end - error Block
         
     } errorBlock:^(NSError *error)
     {
         NSLog(@"-- error %@", error);
     }];
    
}

-(void)getStreamingResultsFromTwitter
    {
        STTwitterAPI *twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
        
        [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
         {
             NSMutableArray *data = [NSMutableArray array];
             NSMutableArray *dataWithCorrectMath = [NSMutableArray array];
             
             
             __block id twitterRequest = [twitter postStatusesFilterUserIDs:nil
                                                            keywordsToTrack:nil
                                                      locationBoundingBoxes:@[@"-180",@"-90",@"180",@"90"]
                                                                  delimited:@20
                                                              stallWarnings:nil
                                                              progressBlock:^(NSDictionary *tweet)
                                          {
                                              
                                              NSLog(@"-- data count: %lu", (unsigned long)[data count]);
                                              
                                              if (([data count] >= self.tweetCountForStreaming) || ([self.searchResultsFromTwitter count] == self.queryCountForRegexSearch))
                                              {
                                                  NSLog(@"-- cancel");
                                                  self.didCompleteRegexQuery = YES;
                                                  [twitterRequest cancel];
                                              }
                                              else
                                              {
                                                  //Lightly parsing the regular expression
                                                  NSString * regex = @"";
                                                  
                                                  regex = [regex stringByReplacingOccurrencesOfString:@"\""
                                                                                           withString:@"\\\""];
                                                  
                                                  BOOL match = [[tweet valueForKey:@"text"] rx_matchesPattern:regex options:NSRegularExpressionAllowCommentsAndWhitespace];
                                                  
                                                  
                                                  
                                                  //adding the item to data
                                                  [data addObject:tweet];
                                                  if (match)
                                                  {
                                                      [dataWithCorrectMath addObject:tweet];
                                                      
                                                      //Storing the search results from Twitter
                                                      self.searchResultsFromTwitter = [[NSArray alloc]initWithArray:dataWithCorrectMath copyItems:YES];
                                                      
                                                  }//end - if statement
                                                  
                                                  
                                                  NSLog(@"%@",[tweet valueForKey:@"text"]);
                                              }
                                              
                                              
                                          } stallWarningBlock:nil
                                                                 errorBlock:^(NSError *error) {
                                                                     NSLog(@"-- error 2: %@", error);
                                                                 }];
             
         } errorBlock:^(NSError *error)
         {
             NSLog(@"-- error %@", error);
         }];
        
    

    
}//end - getSearchResultsFromTwitter

@end

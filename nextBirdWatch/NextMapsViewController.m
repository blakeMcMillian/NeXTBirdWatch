//
//  NextMapsViewController.m
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/30/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import "NextMapsViewController.h"


@interface NextMapsViewController ()

@end

@implementation NextMapsViewController

@synthesize mapView_;


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}//end - preferredStatusBarStyle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self startActivityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    [self setUpInitialChartViews];
     self.numberOfMarkersDrawn = 0;
    [self verifyTwitterAuthenticationData];
    self.arrayOfSearchResultsFromTwitter = [[NSMutableArray alloc]init];
    [self initMapWithDefaultValues];
    [self performSelector:@selector(drawLocationAnnotations) withObject:nil afterDelay:3];
    [self performSelector:@selector(initElementInSet) withObject:nil afterDelay:0.1];
    
}

-(void)setUpInitialChartViews
{
    [self.mapBlurOverlay addSubview:self.sunCircleChart];
    self.sunCircleChart.frame = CGRectMake(27,28,49,49);
    self.sunCircleChart.layer.anchorPoint = CGPointMake(1,1);
    
    [self.mapBlurOverlay addSubview:self.cloudCircleChart];
    self.cloudCircleChart.frame = CGRectMake(99,28,49,49);
    self.cloudCircleChart.layer.anchorPoint = CGPointMake(1,1);
    
    [self.mapBlurOverlay addSubview:self.rainCircleChart];
    self.rainCircleChart.frame = CGRectMake(183,28,49,49);
    self.rainCircleChart.layer.anchorPoint = CGPointMake(1,1);
    
    [self.mapBlurOverlay addSubview:self.snowCircleChart];
    self.snowCircleChart.frame = CGRectMake(256,28,49,49);
    self.snowCircleChart.layer.anchorPoint = CGPointMake(1,1);
    
    [self.mapBlurOverlay addSubview:self.stormCircleChart];
    self.stormCircleChart.frame = CGRectMake(339,28,49,49);
    self.stormCircleChart.layer.anchorPoint = CGPointMake(1,1);
    
}

#pragma mark - Twitter Methods
-(void)verifyTwitterAuthenticationData
{
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         NSLog(@"Authentication = Success !");
         
     } errorBlock:^(NSError *error)
     {
         //Alert
         [self presentStockPopupToUserwithTitle:@"Authentication Error"
                                     andMessage:@"Please visit settings. Could not authenticate this iPhone !"];
         
     }];
    
}//end - verifyTwitterAuthenticationData

#pragma mark - Animations
-(void)startActivityIndicator
{
    [self.activityIndicator setBarColor:[UIColor greenColor]];
    [self.activityIndicator setBarHeight:10.0];
    [self.activityIndicator setBarWidth:50.0];
    [self.activityIndicator setAperture:60.0];
    
    [self.activityIndicator startAnimating];
}

- (void)animateMapBlurOverlay
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 619.5, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"blurView";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 5;
    basicAnimation.springSpeed = 20;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.mapBlurOverlay pop_addAnimation:basicAnimation forKey:@"animateBlurView"];
    
    
    self.mapViewOverlay.alpha = 0.0;
    self.mapViewOverlay.userInteractionEnabled = NO;
}

-(void)getSearchResultsFromTwitterWithGeocode:(NSString*)geoCode
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
     {
         [twitter getSearchTweetsWithQuery:@"sunny OR cloudy OR snowing OR raining OR thundering OR ligntning OR stormy" geocode:geoCode lang:@"" locale:@"" resultType:@"" count:@"300" until:@"" sinceID:@"" maxID:@"" includeEntities:@(0) callback:@"" successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
             
//             NSLog(@"searchMetadata = %@", searchMetadata);
//             NSLog(@"statuses = %@", statuses);
//             
             //Storing the search results from Twitter
             self.searchResultsFromTwitter = [[NSArray alloc]initWithArray:statuses copyItems:YES];
             
             [self.arrayOfSearchResultsFromTwitter addObject:self.searchResultsFromTwitter];
             
         } errorBlock:^(NSError *error)
          {
              NSLog(@"twitter error = %@", error);
              
          }];//end - error Block
         
     } errorBlock:^(NSError *error)
     {
         NSLog(@"-- error %@", error);
     }];
    
}//end - getSearchResultsFromTwitter


#pragma Parsing data from twitter
-(NSArray *)calculatingWeatherResultsFromTwitterArray:(NSArray*)tweetsForState
{
    //Attributes
    WeatherInstance *sun = [[WeatherInstance alloc] init];
    sun.weatherName = @"sun";
    sun.weatherPercentage = 0;
    
    WeatherInstance *cloud = [[WeatherInstance alloc] init];
    cloud.weatherName = @"cloud";
    cloud.weatherPercentage = 0;
    
    WeatherInstance *rain = [[WeatherInstance alloc] init];
    rain.weatherName = @"rain";
    rain.weatherPercentage = 0;
    
    WeatherInstance *snow = [[WeatherInstance alloc] init];
    snow.weatherName = @"snow";
    snow.weatherPercentage = 0;
    
    WeatherInstance *storm = [[WeatherInstance alloc] init];
    storm.weatherName = @"storm";
    storm.weatherPercentage = 0;
    
    double total = 0;
    
    
    //Iterating over the array of user status Dictionaries
    for (NSDictionary* tweetsFromStates in tweetsForState)
    {
        //Populating the tweetINstance Object
        
        //Creating a new tweet object
        self.tweet = [[tweetInstance alloc] init];
        
        self.tweet.tweetText = [tweetsFromStates valueForKey:@"text"];
        
        self.tweet.tweetText = [self.tweet.tweetText lowercaseString];

        if(([self.tweet.tweetText containsString:@"sunny"]))
        {
            sun.weatherPercentage++;
        }
        if(([self.tweet.tweetText containsString:@"cloudy"]))
        {
            cloud.weatherPercentage++;
        }
        if([self.tweet.tweetText containsString:@"raining"])
        {
            rain.weatherPercentage++;
        }
        if(([self.tweet.tweetText containsString:@"snowing"]))
        {
            snow.weatherPercentage++;
        }
        if(([self.tweet.tweetText containsString:@"thundering"]) || ([self.tweet.tweetText containsString:@"lightning"]) || ([self.tweet.tweetText containsString:@"stormy"]))
        {
            storm.weatherPercentage++;
        }
        
        //incrementing the total counter
        total++;

    }//end for - in loop
    
    NSArray *arrayOfWeather = [[NSArray alloc]initWithObjects:sun,cloud,rain,snow,storm, nil];
    
    return arrayOfWeather;
    
}//end - parsing search reuslts from twitter

#pragma mark - Map Methods
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    
    for (NextMapAnnotation *mapMarker in self.annotationCollection)
    {
        NSString *tempName = mapMarker.locationName;
        NSString *markerName = marker.title;
        
        if ([tempName isEqualToString:markerName])
        {
            double weather1 = [[mapMarker.arrayOfWeatherData objectAtIndex:0] weatherPercentage];
            double weather2 = [[mapMarker.arrayOfWeatherData objectAtIndex:1] weatherPercentage];
            double weather3 = [[mapMarker.arrayOfWeatherData objectAtIndex:2] weatherPercentage];
            double weather4 = [[mapMarker.arrayOfWeatherData objectAtIndex:3] weatherPercentage];
            double weather5 = [[mapMarker.arrayOfWeatherData objectAtIndex:4] weatherPercentage];
            //double total = [[mapMarker.arrayOfWeatherData objectAtIndex:5] weatherPercentage];
        

            NSLog(@"%@",mapMarker.locationName);
            [self animateMapBlurOverlay];
            
            [self.barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
            [self.barChart setYValues:@[@(weather1),  @(weather2), @(weather3), @(weather4), @(weather5)]];
            
            [self.barChart strokeChart];
            
            self.mapViewOverlay.alpha = 0.7;
            self.mapViewOverlay.userInteractionEnabled = YES;
            
        }
    }
    
    
}


-(void)initMapWithDefaultValues
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.178181
                                                            longitude:-96.054581
                                                                 zoom:3.3
                                                              bearing:0
                                                         viewingAngle:14];
    
    mapView_.camera = camera;
    mapView_.myLocationEnabled = NO;
    mapView_.settings.compassButton = NO;
    //[mapView_ setMinZoom:1 maxZoom:15];
    mapView_.settings.rotateGestures = NO;
    mapView_.settings.myLocationButton = NO;
    mapView_.mapType = kGMSTypeSatellite;
    mapView_.delegate = self;
    
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(mapViewWasTapped)];
    [mapView_ addGestureRecognizer:tapRec];
    
    //Setting the geoLocation values
    [self settingLocationNamesAndCoordinatesForCities];
    
}


//Need to get the information from Twitter before setting this attribute, because the image needs to be set
-(GMSMarker *)createMapMarkerWithLocationName:(NSString *)locationName locationDescription:(NSString *)locationDescription latitudeValue:(double)latitude longitudeValue:(double)longitude andLocationImage:(UIImage *)locationImage
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = locationName;
    marker.snippet = locationDescription;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = locationImage;
    marker.map = nil; //THIS WILL DRAW THE ANNOTATION
    
    return marker;
    
}//end - createMapMarkerWithDefaultAttributes


-(WeatherInstance*)calculateLargestWeatherOccurance
{
     WeatherInstance *prevailingWeather = [[WeatherInstance alloc]init];
    
    for (NextMapAnnotation *marker in self.annotationCollection)
    {
       
        if (marker.arrayOfWeatherData != nil)
        {
            if ([[marker.arrayOfWeatherData objectAtIndex:0] weatherPercentage] > [[marker.arrayOfWeatherData objectAtIndex:1] weatherPercentage])
            {
                prevailingWeather = [marker.arrayOfWeatherData objectAtIndex:0];
            }
            else
            {
                prevailingWeather = [marker.arrayOfWeatherData objectAtIndex:1];
            }
            if (prevailingWeather.weatherPercentage < [[marker.arrayOfWeatherData objectAtIndex:2] weatherPercentage])
            {
                prevailingWeather = [marker.arrayOfWeatherData objectAtIndex:2];
            }
            if (prevailingWeather.weatherPercentage < [[marker.arrayOfWeatherData objectAtIndex:3] weatherPercentage])
            {
                prevailingWeather = [marker.arrayOfWeatherData objectAtIndex:3];
            }
            if (prevailingWeather.weatherPercentage < [[marker.arrayOfWeatherData objectAtIndex:4] weatherPercentage])
            {
                prevailingWeather = [marker.arrayOfWeatherData objectAtIndex:4];
            }
        }
    }
    
    return prevailingWeather;
}

//Method that will iterate over the set of NextLocationAnnotations and set all of the properties
-(void)drawLocationAnnotations
{
    [self populateLocationsWithTweets];
    
    for (NextMapAnnotation *marker in self.annotationCollection)
    {
        if (marker.arrayOfTweetsForLocation != nil && marker.alreadyDrawn == NO)
        {
            marker.alreadyDrawn = YES;
            
            marker.arrayOfWeatherData = [[NSArray alloc]initWithArray:[self calculatingWeatherResultsFromTwitterArray:marker.arrayOfTweetsForLocation]];
            marker.prevailingWeather = [self calculateLargestWeatherOccurance];
            
            //drawing the marker on the main thread

                marker.marker.map = self.mapView_;
                marker.marker.snippet = marker.prevailingWeather.weatherName;
                
                if ([marker.prevailingWeather.weatherName isEqualToString:@"sun"])
                {
                    marker.marker.icon = [UIImage imageNamed:@"sunIcon@3x.png"];
                }
                else if ([marker.prevailingWeather.weatherName isEqualToString:@"cloud"])
                {
                    marker.marker.icon = [UIImage imageNamed:@"cloudIcon@3x.png"];
                }
                else if ([marker.prevailingWeather.weatherName isEqualToString:@"rain"])
                {
                    marker.marker.icon = [UIImage imageNamed:@"rainIcon@3x.png"];
                }
                else if ([marker.prevailingWeather.weatherName isEqualToString:@"snow"])
                {
                    marker.marker.icon = [UIImage imageNamed:@"snowIcon@3x.png"];
                }
                else if ([marker.prevailingWeather.weatherName isEqualToString:@"storm"])
                {
                    marker.marker.icon = [UIImage imageNamed:@"stormIcon@3x.png"];
                }
            
            self.numberOfMarkersDrawn++;
        }
    }
    if (self.numberOfMarkersDrawn < [self.geoLocations count])
    {
        [NSTimer scheduledTimerWithTimeInterval:6.0
                                         target:self
                                       selector:@selector(drawLocationAnnotations)
                                       userInfo:nil
                                        repeats:YES];
    }
    if (self.numberOfMarkersDrawn > 1)
    {
        self.loadingView.hidden = YES;
    }
    
}

-(void)initElementInSet
{
    self.annotationCollection = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in self.geoLocations)
    {
        
        //Creating a new location object
        self.locationAnnotationInstance = [NextMapAnnotation new];

        //Setting the default Attributes for the annotation
        self.locationAnnotationInstance.locationName = [dict valueForKey:@"cityStateName"];
        
        self.locationAnnotationInstance.marker =
        [self createMapMarkerWithLocationName:[dict valueForKey:@"cityStateName"]
                          locationDescription:self.locationAnnotationInstance.weatherDescription
                                latitudeValue:[[dict valueForKey:@"lat"] doubleValue]
                               longitudeValue:[[dict valueForKey:@"long"] doubleValue]
                             andLocationImage:nil];
        
        //Setting the search results from Twitter to NULL after each query to ensure uniqueness
        self.searchResultsFromTwitter = [NSArray new];
        
        //Performing the query operation on the location
        NSString* longitude = [[dict valueForKey:@"long"] stringValue];
        NSString* latitude = [[dict valueForKey:@"lat"] stringValue];
        
        NSString* geoCode = [NSString stringWithFormat:@"%@,%@,30mi", latitude, longitude];
    
        [self performSelector:@selector(getSearchResultsFromTwitterWithGeocode:) withObject:geoCode afterDelay:5.0];
        
        
        NSArray *temp = [[NSArray alloc]initWithObjects:self.locationAnnotationInstance, nil];
        
        //Adding the element to the array of map annotations
        [self.annotationCollection addObjectsFromArray:temp];
    
        
    }//end - for in - loop
    
}


-(void)populateLocationsWithTweets
{
    //Instance Variables
    int counter = 0;
    
    for (NextMapAnnotation *mapAnn in self.annotationCollection)
    {
        if (counter < [self.arrayOfSearchResultsFromTwitter count])
        {
            mapAnn.arrayOfTweetsForLocation = [[NSArray alloc]initWithArray:[self.arrayOfSearchResultsFromTwitter objectAtIndex:counter] copyItems:YES];
        }
        
        counter++;
    }

}


-(void)settingLocationNamesAndCoordinatesForCities
{
    self.geoLocations = [[NSArray alloc]initWithObjects:
                          @{@"cityStateName":@"Montgomery, Alabama",
                            @"long":@-86.299969,
                            @"lat":@32.366805},
                          @{@"cityStateName":@"Juneau, Alaska",
                            @"long":@-134.419722,
                            @"lat":@58.301944},
                          @{@"cityStateName":@"Phoenix, Arizona",
                            @"long":@-112.074037,
                            @"lat":@33.448377},
                         @{@"cityStateName":@"Little Rock, Arkansas",
                            @"long":@-92.289595,
                           @"lat":@34.746481},
                          @{@"cityStateName":@"Sacramento, California",
                            @"long":@-121.4944,
                            @"lat":@38.581572},
                          @{@"cityStateName":@"Denver, Colorado",
                            @"long":@-104.984859,
                            @"lat":@39.738436},
                          @{@"cityStateName":@"Hartford, Connecticut",
                            @"long":@-72.685093,
                            @"lat":@41.763711},
                          @{@"cityStateName":@"Dover, Delaware",
                            @"long":@-75.524368,
                            @"lat":@39.158168},
                          @{@"cityStateName":@"Florida, Tallahassee",
                            @"long":@-84.280733,
                            @"lat":@30.438256},
                          @{@"cityStateName":@"Atlanta, Georgia",
                            @"long":@-84.3879822,
                            @"lat":@33.748995},
                          @{@"cityStateName":@"Honolulu, Hawaii",
                            @"long":@-157.858333,
                            @"lat":@21.306944},
                          @{@"cityStateName":@"Boise, Idaho",
                            @"long":@-116.214607,
                            @"lat":@43.618710},
                          @{@"cityStateName":@"Springfield, Illinois",
                            @"long":@-89.650148,
                            @"lat":@39.781721},
                          @{@"cityStateName":@"Indianapolis, Indiana",
                            @"long":@-86.158068,
                            @"lat":@39.768403},
                          @{@"cityStateName":@"Des Moines, Iowa",
                            @"long":@-93.609106,
                            @"lat":@41.600545},
                          @{@"cityStateName":@"Topeka, Kansas",
                            @"long":@-95.689018,
                            @"lat":@39.055824},
                          @{@"cityStateName":@"Frankfort, Kentucky",
                            @"long":@-84.873284,
                            @"lat":@38.200905},
                          @{@"cityStateName":@"Baton Rouge, Louisiana",
                            @"long":@-91.14032,
                            @"lat":@30.458283},
                          @{@"cityStateName":@"Augusta, Maine",
                            @"long":@-69.77949,
                            @"lat":@44.310624},
                          @{@"cityStateName":@"Annapolis, Maryland",
                            @"long":@-76.492183,
                            @"lat":@38.978445},
                          @{@"cityStateName":@"Boston, Massachusetts",
                            @"long":@-71.060097,
                            @"lat":@42.358486,},
                          @{@"cityStateName":@"Lansing, Michigan",
                            @"long":@-84.555535,
                            @"lat":@42.732535},
                          @{@"cityStateName":@"Saint Paul, Minnesota",
                            @"long":@-93.089958,
                            @"lat":@44.953703},
                          @{@"cityStateName":@"Jackson, Mississippi",
                            @"long":@-90.18481,
                            @"lat":@32.298757},
                          @{@"cityStateName":@"Jefferson City, Missouri",
                            @"long":@-92.173516,
                            @"lat":@38.576702},
                          @{@"cityStateName":@"Helena, Montana",
                            @"long":@-112.027031,
                            @"lat":@46.595805},
                          @{@"cityStateName":@"Lincoln, Nebraska",
                            @"long":@-96.680278,
                            @"lat":@40.810556},
                          @{@"cityStateName":@"Carson City, Nevada",
                            @"long":@-119.767403,
                            @"lat":@39.163798},
                          @{@"cityStateName":@"Concord, New Hampshire",
                            @"long":@-71.537572,
                            @"lat":@43.208137},
                          @{@"cityStateName":@"Trenton, New Jersey",
                            @"long":@-74.742938,
                            @"lat":@40.217053},
                          @{@"cityStateName":@"Santa Fe, New Mexico",
                            @"long":@-105.937799,
                            @"lat":@35.686975},
                          @{@"cityStateName":@"Albany, New York",
                            @"long":@-73.756232,
                            @"lat":@42.652579},
                          @{@"cityStateName":@"Raleigh, North Carolina",
                            @"long":@-78.638179,
                            @"lat":@35.779590},
                          @{@"cityStateName":@"Bismarck, North Dakota",
                            @"long":@-100.783739,
                            @"lat":@46.808327},
                          @{@"cityStateName":@"Columbus, Ohio",
                            @"long":@-82.998794,
                            @"lat":@39.961176},
                          @{@"cityStateName":@"Oklahoma City, Oklahoma",
                            @"long":@-97.516428,
                            @"lat":@35.467560},
                          @{@"cityStateName":@"Salem, Oregon",
                            @"long":@-123.035096,
                            @"lat":@44.942898},
                          @{@"cityStateName":@"Harrisburg, Pennsylvania",
                            @"long":@-76.886701,
                            @"lat":@40.273191},
                          @{@"cityStateName":@"Providence, Rhode Island",
                            @"long":@-71.412834,
                            @"lat":@41.823989},
                          @{@"cityStateName":@"Columbia, South Carolina",
                            @"long":@-81.034814,
                            @"lat":@34.000710},
                          @{@"cityStateName":@"Nashville, Tennessee",
                            @"long":@-86.781602,
                            @"lat":@36.162664},
                          @{@"cityStateName":@"Austin, Texas",
                            @"long":@-97.743061,
                            @"lat":@30.267153},
                          @{@"cityStateName":@"Salt Lake City, Utah",
                            @"long":@-111.891047,
                            @"lat":@40.760779},
                          @{@"cityStateName":@"Montpelier, Vermont",
                            @"long":@-72.575387,
                            @"lat":@44.260059},
                          @{@"cityStateName":@"Richmond, Virginia",
                            @"long":@-77.436048,
                            @"lat":@37.540725},
                          @{@"cityStateName":@"Charleston, West Virginia",
                            @"long":@-81.632623,
                            @"lat":@38.349820},
                          @{@"cityStateName":@"Madison, Wisconsin",
                            @"long":@-89.40123,
                            @"lat":@43.073052},
                          @{@"cityStateName":@"Cheyenne, Wyoming",
                            @"long":@-104.820246,
                            @"lat":@41.139981},
                         @{@"cityStateName":@"Olympia, Washington",
                           @"long":@-122.900695,
                           @"lat":@47.037874},
                         @{@"cityStateName":@"South Dakota, Pierre",
                           @"long":@-100.350967,
                           @"lat":@44.368316},nil];

}

#pragma popUp
-(void) presentStockPopupToUserwithTitle: (NSString *)popUpTitle andMessage:(NSString *)popUpMessage
{
    //Alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:popUpTitle
                                                    message:popUpMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}//end presentStockPopupToUser

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)mapViewWasTapped
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 858.5, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"blurViewToBack";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 13;
    basicAnimation.springSpeed = 20;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.mapBlurOverlay pop_addAnimation:basicAnimation forKey:@"animateBlurViewToBack"];
}



- (IBAction)mapViewWasTouched:(id)sender
{
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerPosition];
    basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(207, 858.5, 0, 0)];//last 2 values dont matter
    
    // 4. Create Name For Animation & Set Delegate
    basicAnimation.name=@"blurViewToBack";
    basicAnimation.delegate=self;
    //   basicAnimation.velocity = @(60);
    basicAnimation.springBounciness = 13;
    basicAnimation.springSpeed = 20;
    
    // 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
    [self.mapBlurOverlay pop_addAnimation:basicAnimation forKey:@"animateBlurViewToBack"];
    
    self.mapViewOverlay.alpha = 0.0;

}
@end

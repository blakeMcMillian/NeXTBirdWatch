//
//  NextMapsViewController.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/30/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NextMapAnnotation.h"
#import "STTwitter.h"
#import "tweetInstance.h"
#import "WeatherInstance.h"
#import "AMPActivityIndicator.h"
#import <pop/POP.h>
#import "PNChart.h"
#import "PNCircleChart.h"

@interface NextMapsViewController : UIViewController<GMSMapViewDelegate>

//UIView


//GMSMapView
@property (strong, nonatomic) IBOutlet GMSMapView *mapView_;
@property (strong, nonatomic) NSMutableArray *annotationCollection;
@property (strong, nonatomic) NextMapAnnotation *locationAnnotationInstance;
@property (strong, nonatomic) NSArray *geoLocations;

//ActivityIndicator
@property (strong, nonatomic) IBOutlet AMPActivityIndicator *activityIndicator;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *loadingView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *mapBlurOverlay;
@property (strong, nonatomic) IBOutlet UIView *mapViewOverlay;
@property (strong, nonatomic) IBOutlet PNBarChart *barChart;

//Circles
@property (strong, nonatomic) IBOutlet PNCircleChart *sunCircleChart;
@property (strong, nonatomic) IBOutlet PNCircleChart *cloudCircleChart;
@property (strong, nonatomic) IBOutlet PNCircleChart *rainCircleChart;
@property (strong, nonatomic) IBOutlet PNCircleChart *snowCircleChart;
@property (strong, nonatomic) IBOutlet PNCircleChart *stormCircleChart;



//Programetic --------


//NSArray
@property (strong, nonatomic) NSArray* searchResultsFromTwitter;
@property (strong, nonatomic) NSArray* arrayOfTweetsFromTwitterSearch;
@property (strong, nonatomic) NSMutableArray* arrayOfSearchResultsFromTwitter;

//tweetInstance
@property (strong, nonatomic) tweetInstance *tweet;

//STTwitter
@property (nonatomic, strong) STTwitterAPI *twitter;

//CurrentWeather Instance
@property (strong,nonatomic) WeatherInstance *currentWeatherInstance;

//Counter
@property int numberOfMarkersDrawn;

- (IBAction)mapViewWasTouched:(id)sender;


@end

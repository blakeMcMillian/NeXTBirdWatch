//
//  NextMapAnnotation.h
//  nextBirdWatch
//
//  Created by Blake McMillian on 11/30/14.
//  Copyright (c) 2014 Blake McMillian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "weatherInstance.h"

@interface NextMapAnnotation : NSObject


@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) UIImage *locationImage;
@property (strong, nonatomic) NSArray *arrayOfTweetsForLocation;
@property (strong, nonatomic) NSArray *arrayOfWeatherData;
@property (strong, nonatomic) WeatherInstance *prevailingWeather;
@property (strong, nonatomic) WeatherInstance *weatherDictionary;
@property BOOL alreadyDrawn;

@end

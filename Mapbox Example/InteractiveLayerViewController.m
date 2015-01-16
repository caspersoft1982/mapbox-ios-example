//
//  InteractiveLayerViewController.m
//  Mapbox Example
//
//  Copyright (c) 2014 Mapbox, Inc. All rights reserved.
//

#import "InteractiveLayerViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "NSData+Base64.h"

// This map style was built in TileMill, so it doesn't have automatic server-side retina
// mode unlike the other, OpenStreetMap-based maps in this project. 

#define kRegularGeographyClassMapID @"examples.map-zmy97flj"
#define kRetinaGeographyClassMapID  @"examples.1fjyxmhi"

@implementation InteractiveLayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *mapID = ([[UIScreen mainScreen] scale] > 1 ? kRetinaGeographyClassMapID : kRegularGeographyClassMapID);

    RMMapboxSource *interactiveSource = [[RMMapboxSource alloc] initWithMapID:mapID];

    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:interactiveSource];

    mapView.delegate = self;
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
    
    [self.view addSubview:mapView];
}

#pragma mark -

- (void)singleTapOnMap:(RMMapView *)mapView at:(CGPoint)point
{
    [mapView removeAllAnnotations];

    RMMapboxSource *source = (RMMapboxSource *)mapView.tileSource;

    if ([source conformsToProtocol:@protocol(RMInteractiveSource)] && [source supportsInteractivity])
    {
        NSString *formattedOutput = [source formattedOutputOfType:RMInteractiveSourceOutputTypeTeaser
                                                         forPoint:point 
                                                        inMapView:mapView];

        if (formattedOutput && [formattedOutput length])
        {
            // parse the country name out of the content
            //
            NSUInteger startOfCountryName = [formattedOutput rangeOfString:@"<strong>"].location + [@"<strong>" length];
            NSUInteger endOfCountryName   = [formattedOutput rangeOfString:@"</strong>"].location;

            NSString *countryName = [formattedOutput substringWithRange:NSMakeRange(startOfCountryName, endOfCountryName - startOfCountryName)];

            // parse the flag image out of the content
            //
            NSUInteger startOfFlagImage = [formattedOutput rangeOfString:@"base64,"].location + [@"base64," length];
            NSUInteger endOfFlagImage   = [formattedOutput rangeOfString:@"\" style"].location;

            UIImage *flagImage = [UIImage imageWithData:[NSData dataFromBase64String:[formattedOutput substringWithRange:NSMakeRange(startOfFlagImage, endOfFlagImage)]]];

            RMAnnotation *annotation = [RMAnnotation annotationWithMapView:mapView coordinate:[mapView pixelToCoordinate:point] andTitle:countryName];

            annotation.userInfo = flagImage;

            [mapView addAnnotation:annotation];

            [mapView selectAnnotation:annotation animated:YES];
        }
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"embassy"];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 32)];

    imageView.contentMode = UIViewContentModeScaleAspectFit;

    imageView.image = annotation.userInfo;

    marker.leftCalloutAccessoryView = imageView;

    marker.canShowCallout = YES;

    return marker;
}

@end
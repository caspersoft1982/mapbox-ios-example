//
//  OnlineLayerViewController.m
//  Mapbox Example
//
//  Copyright (c) 2014 Mapbox, Inc. All rights reserved.
//

#import "OnlineLayerViewController.h"

#import "Mapbox.h"

#define kMapboxMapID @"examples.map-z2effxa8"

@implementation OnlineLayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    RMMapboxSource *onlineSource = [[RMMapboxSource alloc] initWithMapID:kMapboxMapID];

    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineSource];
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:mapView];
}

@end
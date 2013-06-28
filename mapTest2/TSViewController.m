//
//  TSViewController.m
//  mapTest2
//
//  Created by Syarif on 6/1/13.
//  Copyright (c) 2013 Brainstorm. All rights reserved.
//

#import "TSViewController.h"

@interface TSViewController () <MKMapViewDelegate>

//@property (strong,nonatomic)  MKMapView *mapView;
@property (strong,nonatomic) CLGeocoder *geoCoder;
@property (strong,nonatomic) MKPlacemark *placeMark;
@property (strong,nonatomic) NSArray *locationArray, *locationLatitudeArray;
@property CLLocationCoordinate2D location;
@property MKCoordinateRegion region;
@property MKCoordinateSpan span;
@property MKPointAnnotation *annotationNew;
@property (strong,nonatomic) MKMapView *mapViewNew;

@end

@implementation TSViewController
//@synthesize mapView,
@synthesize geoCoder, placeMark, locationArray, locationLatitudeArray, location,span,region,annotationNew,mapViewNew;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // adding the mapview
}

- (void) viewDidAppear:(BOOL)animated
{
    mapViewNew = [[MKMapView alloc] initWithFrame:CGRectMake(0,
                                                                     100,
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height - 100)];
    [self.view addSubview:mapViewNew];
    [mapViewNew setDelegate:self];
    
    //setting the region
    location.latitude = 3.108977;
    location.longitude = 101.65982;
    span = MKCoordinateSpanMake(0.002, 0.005);
    region = MKCoordinateRegionMake(location, span);
    [mapViewNew setRegion:region];
    
    //annotation stuff
    annotationNew = [[MKPointAnnotation alloc] init];
    [annotationNew setCoordinate:location];
    [annotationNew setTitle:@"This is here"];
    [annotationNew setSubtitle:@"This is there"];
    
    [mapViewNew setZoomEnabled:YES];
    [mapViewNew setScrollEnabled:YES];
    [mapViewNew addAnnotation:annotationNew];
    [mapViewNew viewForAnnotation:annotationNew];
    self.locationArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithDouble:3.1],
                          [NSNumber numberWithDouble:3.2],
                          [NSNumber numberWithDouble:3.3],
                          nil];
    self.locationLatitudeArray = [NSArray arrayWithObjects:
                                  [NSNumber numberWithDouble:101.1],
                                  [NSNumber numberWithDouble:101.2],
                                  [NSNumber numberWithDouble:101.3],
                                  nil];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.view.frame.size.width,
                                                                           100)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
//    [self performSelector:@selector(addAnnotation) withObject:nil afterDelay:2.0];

}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    static NSString*defaultPin=@"pinDrop";
//    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPin];
//
//    if(annotation!=mapView.userLocation)
//    {
//        pinView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPin];
//        
//        if(pinView==nil)
//        {
//            pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPin];
//            pinView.pinColor=MKPinAnnotationColorPurple;
//            pinView.canShowCallout=YES;
//            pinView.animatesDrop=YES;
//            [pinView setSelected:YES animated:YES];
//        }
//    }
//    else
//    {
//        [mapView.userLocation setTitle:@"You are Here!"];
//    }
//    return pinView;
//}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSTimeInterval delayInterval = 0;
    
    for (MKAnnotationView *annView in views)
    {
        // Don't pin drop if annotation is user location
        if ([annView.annotation isKindOfClass:[MKUserLocation class]])
        {
            continue;
        }
                
        CGRect endFrame = annView.frame;
        
        // Move annotation out of view
        annView.frame = CGRectMake(annView.frame.origin.x, annView.frame.origin.y - self.view.frame.size.height, annView.frame.size.width, annView.frame.size.height);
        
        [UIView animateWithDuration:1
                              delay:delayInterval
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             annView.frame = endFrame;
                         }
                         completion:^(BOOL finished){
                                 [self.mapViewNew selectAnnotation:[[self.mapViewNew annotations]objectAtIndex:0]animated:YES];
                         }];
        
        delayInterval += 0.0625;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locationArray.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[NSArray arrayWithObjects:@"Place 1",@"Place 2",@"Place 3", nil]objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    location.latitude = [[locationArray objectAtIndex:indexPath.row] doubleValue];
    location.longitude = [[locationArray objectAtIndex:indexPath.row] doubleValue];
    region = MKCoordinateRegionMake(location, span);
    [mapViewNew removeAnnotation:annotationNew];
//    [self performSelector:@selector(addAnnotation) withObject:nil afterDelay:0.0];
    [mapViewNew setRegion:region];
    [annotationNew setCoordinate:location];
    [mapViewNew addAnnotation:annotationNew];
}

//-(void) addAnnotation
//{
//    
//    [mapViewNew addAnnotation:annotationNew];
//}

@end

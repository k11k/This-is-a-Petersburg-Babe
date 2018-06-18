//
//  AppDelegate.swift
//  OneWeekInStPetersburg
//
//  Created by jsmirnova on 30.05.2018.
//  Copyright © 2018 Julia Smirnova. All rights reserved.
//

import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyC6ZzO2IrlA1vUDXSkzx_JoijP_ENUwWb8")
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let daysListViewController = DaysListViewController(nibName: "DaysListViewController", bundle: nil)
        presentModuleView(viewController: daysListViewController)
        return true
    }
    
    private func presentModuleView(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationItem.backBarButtonItem?.title = " "
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


//- (void)viewDidLoad {
//    [super viewDidLoad];
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.81969
//    longitude:144.966085
//    zoom:4];
//    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//
//    GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
//    sydneyMarker.position = CLLocationCoordinate2DMake(-33.8683, 151.2086);
//    sydneyMarker.map = _mapView;
//
//    _melbourneMarker = [[GMSMarker alloc] init];
//    _melbourneMarker.position = CLLocationCoordinate2DMake(-37.81969, 144.966085);
//    _melbourneMarker.map = _mapView;
//
//    _mapView.delegate = self;
//    self.view = _mapView;
//}
//
//#pragma mark - GMSMapViewDelegate
//
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    if (marker == _melbourneMarker) {
//        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
//    }
//
//    return nil;
//    }
//
//    - (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
//        // Animate to the marker
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:3.f];  // 3 second animation
//
//        GMSCameraPosition *camera =
//            [[GMSCameraPosition alloc] initWithTarget:marker.position
//                zoom:8
//                bearing:50
//                viewingAngle:60];
//        [mapView animateToCameraPosition:camera];
//        [CATransaction commit];
//
//        // Melbourne marker has a InfoWindow so return NO to allow markerInfoWindow to
//        // fire. Also check that the marker isn't already selected so that the
//        // InfoWindow doesn't close.
//        if (marker == _melbourneMarker &&
//            mapView.selectedMarker != _melbourneMarker) {
//            return NO;
//        }
//
//        // The Tap has been handled so return YES
//        return YES;
//}

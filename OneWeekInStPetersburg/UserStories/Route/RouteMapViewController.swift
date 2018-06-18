import UIKit
import Mapbox

class RouteMapViewController: UIViewController {

    var mapView = MGLMapView()
    var firstMarker = MGLPointAnnotation()
    var metroMarkers = [MGLPointAnnotation]()
    var objectMarkers = [MGLPointAnnotation]()
    var zoomView = UITextView()
    var nextMode: Int = 0
    var levelPickerView = UIPickerView()
    var firstLocationUpdate: Bool = false
    
        
    private var viewModel: RouteMapViewModel! {
        didSet {
            viewModel.addObjects.bind { [weak self] objects in
                guard let objects = objects else { return }
                self?.fillObjects(objects: objects)
            }
            viewModel.removeObjects.bind { [weak self] objects in
            guard let objects = objects else { return }
                self?.removeObjects(objects: objects)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Маршрут"
        setupMapView()
        viewModel = RouteMapViewModel()
        setUpMetroButton()
        viewModel.addObjects.fire()
    }
    
    @objc func didTapAddMetroButton() {
        viewModel.addMetroToViewButtonTapped()
    }
    
    func setupMapView() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.9301091, longitude: 30.3619787), zoomLevel: 16.0, animated: false)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func fillObjects(objects: [MGLAnnotation]) {
       mapView.addAnnotations(objects)
    }
    
    func removeObjects(objects: [MGLAnnotation]) {
        mapView.removeAnnotations(objects)
    }
    
    
    func setUpMetroButton() {
        let image = UIImage(named: "MetroButtonImage")
        let button: UIButton = UIButton()
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(didTapAddMetroButton), for: .touchDown)
        
        let rightItem: UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        navigationItem.rightBarButtonItem = rightItem
    }
}

extension RouteMapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        guard let mapObject = annotation as? MapObject else { return nil }
        let annotationImage = MGLAnnotationImage(image: mapObject.structModel.mapIconView, reuseIdentifier: mapObject.structModel.mapTitle) 
        return annotationImage
    }
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        guard let mapObject = annotation as? MapObject,
            let objectModel = mapObject.structModel as? ObjectModel else { return }
        let vc  = ObjectDescriptionViewController(nibName: "ObjectDescriptionViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        vc.openWithObject(objectModel)
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        guard let mapObject = annotation as? MapObject,
        let objectModel = mapObject.structModel as? ObjectModel else { return nil }
        let imageView = UIImageView(image: objectModel.image)
        let size = CGSize(width: 60, height: 50)
        imageView.frame.size = size
        return imageView
    }
}

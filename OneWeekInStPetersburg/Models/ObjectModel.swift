import CoreLocation
import UIKit
import Mapbox

enum Category: String {
    case food
    case showPlace
    case bridge
    case hotel
}

protocol MapPin {
    var mapCoordinates: CLLocationCoordinate2D { get }
    var mapTitle: String { get }
    var mapSubTitle: String { get }
    var mapIconView: UIImage { get }
}

struct ObjectModel {
    var category: Category
    var cordinate: CLLocationCoordinate2D
    var title: String
    var image: UIImage
    var images: [UIImage]?
    var address: String
    var mode: String
    var description: String
    var metro: [MetroModel]?
    var metroIds: [String]
    
    static func parseObeject(_ json: JSONData) -> ObjectModel? {
        guard let categoryStringValue = json["category"] as? String,
            let category = Category(rawValue: categoryStringValue),
            let title = json["title"] as? String,
            let imageName = json["image"] as? String,
            let address = json["address"] as? String,
            let mode = json["mode"] as? String,
            let description = json["description"] as? String,
            let coordinateDict = json["cordinate"] as? [String: Double] else {
                return nil
        }
        let image = UIImage(named: imageName)!
        var images = [UIImage]()
        if let imageNames = json["images"] as? [String] {
            imageNames.forEach({images.append(UIImage(named: $0)!)})
        }
        let coordinates = CLLocationCoordinate2D(latitude: coordinateDict["latitude"]!, longitude: coordinateDict["longitude"]!)
        let metroIds = json["metro"] as? [String] ?? [String]()
        let object = ObjectModel(category: category,
                                 cordinate: coordinates,
                                 title: title,
                                 image: image,
                                 images: images,
                                 address: address,
                                 mode: mode,
                                 description: description,
                                 metro: nil,
                                 metroIds: metroIds)
        return object
    }
}

extension ObjectModel: MapPin {
    var mapCoordinates: CLLocationCoordinate2D {
        return cordinate
    }
    
    var mapTitle: String {
        return title
    }
    
    var mapSubTitle: String {
        return description
    }
    
    var mapIconView: UIImage {
        let image: UIImage
        switch category {
        case .food:
            image = UIImage(named: "CafePin")!
        case .showPlace:
            image = UIImage(named: "ShowPlacePin")!
        case .bridge:
            image = UIImage(named: "BridgePin")!
        case .hotel:
            image = UIImage(named: "CafePin")!
        }
        return image
    }
}

class MapObject: NSObject, MGLAnnotation {
    
    var structModel: MapPin
    
    init(with structModel: MapPin) {
        self.structModel = structModel
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return structModel.mapCoordinates
    }
    
    var title: String? {
        return structModel.mapTitle
    }
    
    var subtitle: String? {
        return structModel.mapSubTitle
    }
}


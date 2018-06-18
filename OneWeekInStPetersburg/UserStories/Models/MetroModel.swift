import UIKit
import CoreLocation
import HexColors
import Mapbox

struct MetroModel {
    var id: String
    var order: Int
    var name: String
    var color: UIColor
    var coordinates: CLLocationCoordinate2D
    
    static func parseStation(stationJson: JSONData, color: String) -> MetroModel? {
        guard
            let order = stationJson["order"] as? Int,
            let id = stationJson["id"] as? String,
            let lat = stationJson["lat"] as? Double,
            let lng = stationJson["lng"] as? Double,
            let name = stationJson["name"] as? String else { return nil }
        let metro = MetroModel(id: id,
                               order: order,
                               name: name,
                               color: UIColor(color)!,
                               coordinates: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        return metro        
    }
}

extension MetroModel: MapPin {
    var mapCoordinates: CLLocationCoordinate2D {
        return coordinates
    }
    
    var mapTitle: String {
        return name
    }
    
    var mapSubTitle: String {
        return ""
    }
    
    var mapIconView: UIImage {
        var image = UIImage(named: "Metro")!
        return image.maskWithColor(color: color)!
    }
}

import Foundation
import Mapbox

class RouteMapViewModel {
    
    let addObjects: Dynamic<[MGLAnnotation]?> = Dynamic(nil)
    let removeObjects: Dynamic<[MGLAnnotation]?> = Dynamic(nil)
    
    private lazy var metroModelsClasses: [MGLAnnotation] = {
        let metrModelsClasses: [MapObject] = metroModels.map{MapObject(with: $0)}
        return metrModelsClasses
    }()
    
    private lazy var metroModels: [MetroModel] = {
        guard let data = Data.fromFileName("Metro", ofType: "json") else { return [] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONData else {
            return []
        }
        let parser = Parser()
        return parser.parseMetroList(dictionary!)
    }()
    
    private var isMetroRemoved: Bool = true
    
    init() {
         getFirstDayObjects()
    }
    
    func addMetroToViewButtonTapped() {
        if isMetroRemoved {
            addObjects.value = metroModelsClasses
            isMetroRemoved = false
        } else {
            removeObjects.value = metroModelsClasses
            isMetroRemoved = true
        }
    }
    
    private func getFirstDayObjects() {
        guard let data = Data.fromFileName("FirstDayObjects", ofType: "json") else { return }
        guard let objectsArray = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [JSONData] else {
            return
        }
        let parser = Parser()
        let result: [ObjectModel] = parser.parseObjects(objectsArray!)
        let objects = parser.addMetroToObjects(metroModels: metroModels, objects: result)
        let objectItems = objects.map{MapObject(with: $0)}
        
        addObjects.value = objectItems
    }
}

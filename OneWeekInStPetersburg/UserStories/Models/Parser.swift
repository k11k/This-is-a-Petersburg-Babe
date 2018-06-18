import Foundation

class Parser {
    func parseMetroList(_ json: JSONData) -> [MetroModel] {
        guard let lines = json["lines"] as? [JSONData] else { return [] }
        var metroItems = [MetroModel]()
        for lineJson in lines {
            metroItems += parseline(lineJson: lineJson)
        }
        return metroItems
    }
    
    private func parseline(lineJson: JSONData) -> [MetroModel] {
        guard let color = lineJson["hex_color"] as? String,
            var stations = lineJson["stations"] as? [JSONData] else { return [] }
        let metroItems = stations.map { jsonStation -> MetroModel? in
            MetroModel.parseStation(stationJson: jsonStation, color: color)
        }
        let metroItemsWithoutNil = metroItems.filter { $0 != nil } as! [MetroModel]
        return metroItemsWithoutNil
    }
    
    func parseObjects(_ arrayObjects: [JSONData]) -> [ObjectModel] {
        var objectItems = [ObjectModel]()
        arrayObjects.forEach {
            if let object = ObjectModel.parseObeject($0) {
                objectItems.append(object)
            }
        }
        return objectItems
    }
    
    func addMetroToObjects(metroModels: [MetroModel], objects: [ObjectModel]) -> [ObjectModel] {
        var objectsWithMetro: [ObjectModel] = []
        for object in objects {
            var newObject = object
            newObject.metro = metroModels.filter({object.metroIds.contains($0.id)})
            objectsWithMetro.append(newObject)
        }
        return objectsWithMetro
    }
}

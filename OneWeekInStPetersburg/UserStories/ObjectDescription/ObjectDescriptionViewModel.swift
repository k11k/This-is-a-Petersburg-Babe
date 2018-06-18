import UIKit

class ObjectDescriptionViewModel {
    var objectName: Dynamic<String?> = Dynamic(nil)
    var images: Dynamic<[UIImage]?> = Dynamic(nil)
    var imagesCount: Dynamic<Int?> = Dynamic(nil)
    var metroInfo: Dynamic<[String: UIColor]?> = Dynamic(nil)
    var description: Dynamic<String?> = Dynamic(nil)
    
    init(_ objectModel: ObjectModel) {
        objectName.value = objectModel.title
        images.value = objectModel.images
        imagesCount.value = objectModel.images?.count
        if let metroItems = objectModel.metro {
            metroInfo.value = parseMetro(metroItems)
        }
        description.value = objectModel.description
    }
    
    func fireAllValues() {
        objectName.fire()
        images.fire()
        imagesCount.fire()
        metroInfo.fire()
        description.fire()
    }
    
    private func parseMetro(_ metroItems: [MetroModel]) -> [String: UIColor] {
        var metroInfo = [String: UIColor]()
        for metro in metroItems {
            metroInfo[metro.name] = metro.color
        }
        return metroInfo
    }
}

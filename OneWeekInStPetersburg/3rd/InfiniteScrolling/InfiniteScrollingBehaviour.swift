import UIKit

public protocol InfiniteScrollingBehaviourDelegate: class {
    func configuredCell(forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell
    
    func didSelectItem(atIndexPath indexPath: IndexPath, originalIndex: Int, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> Void
    
    func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour, _ scrollView: UIScrollView)
    
    func scrollViewWillBeginDragging(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour, _ scrollView: UIScrollView)
}

public extension InfiniteScrollingBehaviourDelegate {
    func didSelectItem(atIndexPath indexPath: IndexPath, originalIndex: Int, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> Void { }
    
    func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour, _ scrollView: UIScrollView) { }
    
    func scrollViewWillBeginDragging(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour, _ scrollView: UIScrollView) { }
    
    func scrollViewWillBeginDecelerating(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour, _ scrollView: UIScrollView) { }
    
}

public enum LayoutType {
    case fixedSize(sizeValue: CGFloat)
    case numberOfCellOnScreen(Double)
}

public struct CollectionViewConfiguration {
    public let scrollingDirection: UICollectionViewScrollDirection
    public var layoutType: LayoutType
    public static let `default` = CollectionViewConfiguration(layoutType: .numberOfCellOnScreen(5), scrollingDirection: .horizontal)
    
    public init(layoutType: LayoutType, scrollingDirection: UICollectionViewScrollDirection) {
        self.layoutType = layoutType
        self.scrollingDirection = scrollingDirection
    }
}

public class InfiniteScrollingBehaviour: NSObject {
    fileprivate var cellSize: CGFloat = 0.0
    fileprivate var numberOfBoundaryElements = 0
    fileprivate(set) public weak var collectionView: UICollectionView!
    fileprivate(set) public weak var delegate: InfiniteScrollingBehaviourDelegate?
    fileprivate(set) public var itemsCount: Int = 0
    fileprivate(set) public var indexes: [Int] = []
    
    fileprivate var sectionInset: CGFloat {
        return flowLayout.scrollDirection == .horizontal ?
            flowLayout.sectionInset.left + flowLayout.sectionInset.right :
            flowLayout.sectionInset.right + flowLayout.sectionInset.bottom
    }
    
    fileprivate var padding: CGFloat {
        return flowLayout.scrollDirection == .horizontal ?
            flowLayout.minimumLineSpacing :
            flowLayout.minimumInteritemSpacing
    }
    
    fileprivate var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    fileprivate var dataContentSize: CGFloat {
        let cgItemsCount = itemsCount.cgFloat
        return sectionInset + padding * cgItemsCount + cellSize * cgItemsCount
    }
    
    fileprivate var collectionViewBoundsValue: CGFloat {
        get {
            switch collectionConfiguration.scrollingDirection {
            case .horizontal:
                return collectionView.bounds.size.width
            case .vertical:
                return collectionView.bounds.size.height
            }
        }
    }
    
    fileprivate var scrollViewContentSizeValue: CGFloat {
        get {
            switch collectionConfiguration.scrollingDirection {
            case .horizontal:
                return collectionView.contentSize.width
            case .vertical:
                return collectionView.contentSize.height
            }
        }
    }
    
    fileprivate(set) public var collectionConfiguration: CollectionViewConfiguration
    
    public init(withCollectionView collectionView: UICollectionView, itemsCount: Int, delegate: InfiniteScrollingBehaviourDelegate, configuration: CollectionViewConfiguration = .default) {
        self.collectionView = collectionView
        self.itemsCount = itemsCount
        self.collectionConfiguration = configuration
        self.delegate = delegate
        super.init()
        configureBoundariesForInfiniteScroll()
        configureCollectionView()
        scrollToFirstElement()
    }
    
    
    private func configureBoundariesForInfiniteScroll() {
        indexes = Array(0..<itemsCount)
        calculateCellWidth()
        let absoluteNumberOfElementsOnScreen = ceil(collectionViewBoundsValue/cellSize)
        numberOfBoundaryElements = Int(absoluteNumberOfElementsOnScreen)
        if dataContentSize >= collectionViewBoundsValue {
            addLeadingBoundaryElements()
            addTrailingBoundaryElements()
        }
    }
    
    private func calculateCellWidth() {
        switch collectionConfiguration.layoutType {
        case .fixedSize(let sizeValue):
            cellSize = sizeValue
        case .numberOfCellOnScreen(let numberOfCellsOnScreen):
            cellSize = (collectionViewBoundsValue/numberOfCellsOnScreen.cgFloat)
        }
    }
    
    private func addLeadingBoundaryElements() {
        for index in stride(from: numberOfBoundaryElements, to: 0, by: -1) {
            let indexToAdd = (itemsCount - 1) - ((numberOfBoundaryElements - index) % itemsCount)
            indexes.insert(indexToAdd, at: 0)
        }
    }
    
    private func addTrailingBoundaryElements() {
        for index in 0..<numberOfBoundaryElements {
            indexes.append(index % itemsCount)
        }
    }
    
    private func configureCollectionView() {
        guard let _ = self.delegate else { return }
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func scrollToFirstElement() {
        let boundarySize = numberOfBoundaryElements.cgFloat * cellSize + (numberOfBoundaryElements.cgFloat * padding)
        let offset = boundarySize - padding + sectionInset
        let updatedOffsetPoint = collectionConfiguration.scrollingDirection == .horizontal ?
            CGPoint(x: offset, y: 0) :
            CGPoint(x: 0, y: offset)
        collectionView.contentOffset = updatedOffsetPoint
    }
    
    public func indexInOriginalDataSet(forIndexInBoundaryDataSet index: Int) -> Int {
        if numberOfBoundaryElements > indexes.count {
            return index
        }
        
        let difference = index - numberOfBoundaryElements
        if difference < 0 {
            let originalIndex = itemsCount + difference
            return abs(originalIndex % itemsCount)
        } else if difference < itemsCount {
            return difference
        } else {
            return abs((difference - itemsCount) % itemsCount)
        }
    }
    
    public func indexInBoundaryDataSet(forIndexInOriginalDataSet index: Int) -> Int {
        if numberOfBoundaryElements <= indexes.count {
            return index + numberOfBoundaryElements
        } else {
            return index
        }
    }
    
    public func reload(itemsCount: Int) {
        self.itemsCount = itemsCount
        configureBoundariesForInfiniteScroll()
        collectionView.reloadData()
    }
}

extension InfiniteScrollingBehaviour: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionConfiguration.scrollingDirection == .horizontal ? CGSize(width: cellSize, height: collectionView.bounds.size.height) : CGSize(width: collectionView.bounds.size.width, height: cellSize)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let originalIndex = indexInOriginalDataSet(forIndexInBoundaryDataSet: indexPath.item)
        delegate?.didSelectItem(atIndexPath: indexPath, originalIndex: originalIndex, inInfiniteScrollingBehaviour: self)
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.frame.width < scrollViewContentSizeValue {
            let boundarySize = numberOfBoundaryElements.cgFloat * cellSize + (numberOfBoundaryElements.cgFloat * padding)
            let contentOffsetValue = collectionConfiguration.scrollingDirection == .horizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
            if contentOffsetValue >= (scrollViewContentSizeValue - boundarySize) {
                let offset = boundarySize - padding + sectionInset
                let updatedOffsetPoint = collectionConfiguration.scrollingDirection == .horizontal ?
                    CGPoint(x: offset, y: 0) : CGPoint(x: 0, y: offset)
                collectionView.contentOffset = updatedOffsetPoint
            } else if contentOffsetValue <= 0 {
                let boundaryLessSize = itemsCount.cgFloat * cellSize + (itemsCount.cgFloat * padding)
                let updatedOffsetPoint = collectionConfiguration.scrollingDirection == .horizontal ?
                    CGPoint(x: boundaryLessSize, y: 0) : CGPoint(x: 0, y: boundaryLessSize)
                collectionView.contentOffset = updatedOffsetPoint
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.didEndScrolling(inInfiniteScrollingBehaviour: self, scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging(inInfiniteScrollingBehaviour: self, scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndScrolling(inInfiniteScrollingBehaviour: self, scrollView)
    }
}

extension InfiniteScrollingBehaviour: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexes.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let delegate = self.delegate else {
            return UICollectionViewCell()
        }
        
        let originalIndex = indexInOriginalDataSet(forIndexInBoundaryDataSet: indexPath.item)
        return delegate.configuredCell(forItemAtIndexPath: indexPath, originalIndex: originalIndex, forInfiniteScrollingBehaviour: self)
    }
}

extension Double {
    var cgFloat: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}

extension Int {
    var cgFloat: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}

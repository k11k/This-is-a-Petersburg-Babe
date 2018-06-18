import UIKit

class ObjectDescriptionViewController: UIViewController {

    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var metroStackView: UIStackView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pageControlHeight: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    
    private var infiniteScrollingBehaviour: InfiniteScrollingBehaviour?
    
    var viewModel: ObjectDescriptionViewModel! {
        didSet {
            viewModel.objectName.bind { [weak self] name in
                self?.objectNameLabel?.text = name
                self?.setupNameLabelSize()
            }
            viewModel.imagesCount.bind { [weak self] count in
                guard let count = count else { return }
                if count == 0 {
                    self?.imageCollectionViewHeight?.constant = 0
                    self?.imageCollectionView.isHidden = true
                    self?.pageControlHeight?.constant = 0
                    self?.pageControl.isHidden = true
                }
                self?.pageControl?.numberOfPages = count
            }
            viewModel.metroInfo.bind { [weak self] metroInfo in
                guard let metroInfo = metroInfo else {
                    self?.metroStackView.isHidden = true
                    return
                }
                if metroInfo.keys.count == 0 {
                    self?.metroStackView.isHidden = true
                }
                self?.setupWithMetro(metroInfo)
            }
            viewModel.images.bind { [weak self] images in
                guard let images = images else {
                    return
                }
                self?.updateWithImages(images)
            }
            viewModel.description.bind { [weak self] description in
                self?.descriptionLabel?.text = description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionView.register(UINib(nibName: "ObjectImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ObjectImageCollectionViewCell")
        viewModel?.fireAllValues()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageCollectionView.layoutIfNeeded()
        
        guard infiniteScrollingBehaviour == nil,
            let count = viewModel.imagesCount.value else { return }
        
        print("imageCollectionView.frame.width = \(imageCollectionView.frame.width)")
        let configuration = CollectionViewConfiguration(layoutType: .fixedSize(sizeValue: imageCollectionView.frame.width),
                                                        scrollingDirection: .horizontal)
        infiniteScrollingBehaviour = InfiniteScrollingBehaviour(withCollectionView: imageCollectionView,
                                                                itemsCount: count,
                                                                delegate: self,
                                                                configuration: configuration)
        
    }
    
    func openWithObject(_ objectModel: ObjectModel) {
        viewModel = ObjectDescriptionViewModel(objectModel)
    }
    
    //MARK: Private
    private func setupWithMetro(_ metroInfo: [String : UIColor]) {
        for metrInfoItem in metroInfo {
            let view = MetroInfoView.instantiateFromXib()
            view.setupView(with: metrInfoItem.value, text: metrInfoItem.key)
            metroStackView.addArrangedSubview(view)
        }
    }
    
    private func updateWithImages(_ images: [UIImage]) {
        imageCollectionView.reloadData()
    }
    
    private func setupNameLabelSize() {
        nameLabelHeightConstraint.constant = objectNameLabel.sizeThatFits(objectNameLabel.frame.size).height
    }
    
    fileprivate func setupCurrentPageForPageControl(_ behaviour: InfiniteScrollingBehaviour, _ pageNumber: Int) {
        let page = behaviour.indexInOriginalDataSet(forIndexInBoundaryDataSet: pageNumber)
        if page != pageControl.currentPage {
            pageControl.currentPage = page
        }
    }
}

extension ObjectDescriptionViewController: InfiniteScrollingBehaviourDelegate {
    func configuredCell(forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ObjectImageCollectionViewCell", for: indexPath) as! ObjectImageCollectionViewCell
        guard let image = viewModel.images.value?[originalIndex] else { return cell}
        cell.setupWithImage(image)
        return cell
    }
    
    func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour, _ scrollView: UIScrollView) {
        let pageNumber: Int = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        setupCurrentPageForPageControl(behaviour, pageNumber)
    }
}



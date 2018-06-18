import Foundation

/// Класс обеспечивает уведомление View о изменении состояния ViewModel
///
/// - note: Подробнее [Web site](https://www.toptal.com/ios/swift-tutorial-introduction-to-mvvm),
/// раздел 'Making the ViewModel Dynamic'.
///
/// Например:
/// **SomeViewModel.swift**
///
///     class SomeViewModel()
/// Объявление объекта, видимого во View:
///
///     let error: Dynamic<Error> { get }
///
/// Инициализация пустым значением:
///
///     - init() {
///        self.error = Dynamic(nil)
///        ...
///     }
/// Измение значения:
///
///     func errorReceived(error: NSError) {
///           self.error.value = error
///     }
/// В **SomeViewController.swift** сработает подписка.

class Dynamic<T> {
    typealias ListenerClosure = (T) -> ()
    typealias Listener = ObjectWrapper<(ListenerClosure)>
    var listeners = NSPointerArray.strongObjects()
    
    /// Метод добавляет подписку на изменение значения наблюдаемго объекта.
    ///
    /// - Parameters:
    ///      - listener: Замыкание к событию didSet наблюдаемого объекта.
    ///
    /// Например:
    /// **SomeViewController.swift**
    ///
    ///     viewModel: SomeViewModel { didSet {
    ///         viweModel.error.bind { [weak self] in error
    ///             print(error)
    ///         }
    ///         ....
    ///     }
    func bind(_ listener: ListenerClosure?) {
        guard let listener = listener else {
            return
        }
        listeners.addObject(ObjectWrapper(value: listener))
        listeners.compact()
    }
    
    /// Метод добавляет подписку на изменение значения наблюдаемого объекта и тут же выполняет зависимый код.
    ///
    /// - Parameters:
    ///      - listener: Замыкание к событию didSet наблюдаемого свойства.
    ///
    /// Например:
    /// **SomeViewController.swift**
    ///
    ///     viewModel: SomeViewModel { didSet {
    ///         viweModel.error.bindAndFire { [weak self] in error
    ///             print(error)
    ///         }
    ///         ....
    ///     }
    func bindAndFire(_ listener: ListenerClosure?) {
        listener?(value)
        bind(listener)
    }
    
    /// Наблюдаемый объект.
    var value: T {
        didSet {
            fire()
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    /// Принудительно заставляет сработать событие по подписке, как если бы произошел didSet.
    ///
    /// - note:
    /// Полезно, если измение свойств наблюдаемого объекта не привели к возникновению события didSet.
    func fire() {
        listeners
            .allObjects
            .forEach({
                ($0 as? Listener)?.value(value)
            })
    }
    
    /// Обновляет значение без срабатывания триггера.
    func updateSilently(_ value: T) {
        let listeners = self.listeners
        self.listeners = NSPointerArray.weakObjects()
        self.value = value
        self.listeners = listeners
    }
}


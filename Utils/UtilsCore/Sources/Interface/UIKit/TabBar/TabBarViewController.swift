//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

public final class TabBarViewController<TabBarView: TabBarViewable>: UIViewController {
    public typealias ItemView = TabBarView.ItemView
    public typealias SelectHandler = (_ item: TabBarItem<ItemView>, _ consecutive: Bool) -> Void
    
    public enum ChildLayout: Equatable {
        case barPinned(contentOffset: CGFloat)
        case fullHeight
    }
    
    public enum TabPivot {
        case top
        case topSafeArea
        case bottom
        case bottomSafeArea
    }

    public var tabs: [TabBarItem<ItemView>] {
        didSet {
            renderTabs()
        }
    }

    public var selectedTab: TabBarItem<ItemView>? {
        tabs[safe: selectedIndex]
    }

    public override var childForStatusBarStyle: UIViewController? {
        showedController
    }

    public override var childForStatusBarHidden: UIViewController? {
        showedController
    }

    public override var childForHomeIndicatorAutoHidden: UIViewController? {
        showedController
    }

    public override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        showedController
    }
    
    public override var prefersHomeIndicatorAutoHidden: Bool {
        showedController?.prefersHomeIndicatorAutoHidden ?? true
    }

    public override var prefersStatusBarHidden: Bool {
        showedController?.prefersStatusBarHidden ?? true
    }

    public var onTabSelect: SelectHandler?
    public var inreasesSafeArea: Bool

    public init(
        layout: ChildLayout = .barPinned(contentOffset: 0),
        inreasesSafeArea: Bool = true,
        tabPivot: TabPivot = .bottomSafeArea,
        tabBarView: TabBarView,
        tabs: [TabBarItem<ItemView>] = []
    ) {
        self.tabs = tabs
        self.inreasesSafeArea = inreasesSafeArea
        self.layout = layout
        self.tabPivot = tabPivot
        self.tabBarView = tabBarView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews(containerView, tabBarView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        switch layout {
        case .fullHeight:
            containerView.topAnchor.constraint(equalTo: view.topAnchor).activate()
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        case .barPinned(let contentOffset):
            switch tabPivot {
            case .bottom, .bottomSafeArea:
                containerView.topAnchor.constraint(equalTo: view.topAnchor).activate()
                containerView.bottomAnchor.constraint(
                    equalTo: tabBarView.topAnchor,
                    constant: -contentOffset
                ).activate()
            case .top, .topSafeArea:
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
                containerView.topAnchor.constraint(
                    equalTo: tabBarView.bottomAnchor,
                    constant: contentOffset
                ).activate()
            }
        }
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.onSelect = { [weak self] item, index in
            self?.handleTabSelected(item: item, at: index)
        }
        
        NSLayoutConstraint.activate([
            tabBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        switch tabPivot {
        case .bottom, .bottomSafeArea:
            tabBarView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -tabBarView.height
            ).activate()
        case .top, .topSafeArea:
            tabBarView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: tabBarView.height
            ).activate()
        }
        
        switch tabPivot {
        case .bottom:
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        case .bottomSafeArea:
            tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).activate()
        case .top:
            tabBarView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        case .topSafeArea:
            tabBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        }

        renderTabs()
    }

    public func tab(with id: TabBarItem<ItemView>.ID) -> TabBarItem<ItemView>? {
        tabs.first { $0.id == id }
    }

    public func tabIndex(with id: TabBarItem<ItemView>.ID) -> Int? {
        tabs.firstIndex { $0.id == id }
    }

    public func selectTab(with id: TabBarItem.ID, animated: Bool) {
        guard let index = tabIndex(with: id) else {
            assertionWrapperFailure("Failed to select tab with id", "unknown tab id: \(id)")
            return
        }

        selectTab(at: index, animated: animated)
    }

    public func selectTab(at index: Int, animated: Bool) {
        guard let item = tabs[safe: index] else {
            assertionWrapperFailure("Failed to select tab at index", "unknown tab index: \(index)")
            return
        }

        selectedIndex = index
        tabBarView.selectItem(at: selectedIndex, animated: animated)
        showController(item.viewController)
    }

    private func showController(_ controller: UIViewController) {
        showedController?.dropFromParent()
        add(fullscreenChild: controller, in: containerView)
        showedController = controller
        updateShowedControllerSafeAreaInsets()
        
        setNeedsStatusBarAppearanceUpdate()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    
    private func updateShowedControllerSafeAreaInsets() {
        if layout == .fullHeight, inreasesSafeArea {
            showedController?.additionalSafeAreaInsets.bottom = tabBarView.height
        }
    }

    private func renderTabs() {
        tabBarView.items = tabs.map(\.itemView)
        selectTab(at: selectedIndex, animated: false)
    }

    private func handleTabSelected(item: ItemView, at index: Int) {
        guard let tab = tabs[safe: index] else {
            return
        }
    
        guard selectedIndex != index else {
            onTabSelect?(tab, true)
            return
        }
    
        onTabSelect?(tab, false)
        selectedIndex = index
        selectTab(at: index, animated: true)
    }

    private var selectedIndex: Int = 0
    private let containerView = UIView()
    private let tabBarView: TabBarView
    private let layout: ChildLayout
    private let tabPivot: TabPivot
    private var showedController: UIViewController?
}

private extension NSLayoutConstraint {
    func activate() {
        isActive =  true
    }
}
#endif

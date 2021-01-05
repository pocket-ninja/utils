//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

#if os(iOS)
public protocol TabBarViewControllerDelegate: AnyObject {
    func tabBar(_ controller: TabBarViewController, didSelect tab: TabBarItem)
    func tabBar(_ controller: TabBarViewController, didConsecutivelySelect tab: TabBarItem)
}

public extension TabBarViewControllerDelegate {
    func tabBar(_ controller: TabBarViewController, didSelect tab: TabBarItem) {}
    func tabBar(_ controller: TabBarViewController, didConsecutivelySelect tab: TabBarItem) {}
}

public final class TabBarViewController: UIViewController {
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

    public var tabs: [TabBarItem] {
        didSet {
            renderTabs()
        }
    }

    public var selectedTab: TabBarItem? {
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

    public weak var delegate: TabBarViewControllerDelegate?

    public init(
        layout: ChildLayout = .barPinned(contentOffset: 0),
        tabPivot: TabPivot = .bottomSafeArea,
        tabBarView: TabBarViewable,
        tabs: [TabBarItem] = []
    ) {
        self.tabs = tabs
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
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        switch layout {
        case .fullHeight:
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        case .barPinned(let contentOffset):
            switch tabPivot {
            case .bottom, .bottomSafeArea:
                containerView.bottomAnchor.constraint(
                    equalTo: tabBarView.topAnchor,
                    constant: -contentOffset
                ).activate()
            case .top, .topSafeArea:
                containerView.topAnchor.constraint(
                    equalTo: tabBarView.bottomAnchor,
                    constant: contentOffset
                ).activate()
            }
        }
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.delegate = self
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

    public func tab(with id: TabBarItem.ID) -> TabBarItem? {
        tabs.first { $0.id == id }
    }

    public func tabIndex(with id: TabBarItem.ID) -> Int? {
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
        if layout == .fullHeight {
            showedController?.additionalSafeAreaInsets.bottom = tabBarView.height
        }
    }

    private func renderTabs() {
        tabBarView.items = tabs.map(\.itemView)
        selectTab(at: selectedIndex, animated: false)
    }

    private var selectedIndex: Int = 0
    private let containerView = UIView()
    private let tabBarView: TabBarViewable
    private let layout: ChildLayout
    private let tabPivot: TabPivot
    private var showedController: UIViewController?
}

extension TabBarViewController: TabBarViewDelegate {
    public func tabBarView(_ view: TabBarViewable, tappedOn: TabBarItemViewable, at index: Int) {
        guard let tab = tabs[safe: index] else {
            return
        }

        guard selectedIndex != index else {
            delegate?.tabBar(self, didConsecutivelySelect: tab)
            return
        }

        delegate?.tabBar(self, didSelect: tab)
        selectedIndex = index
        selectTab(at: index, animated: true)
    }
}

private extension NSLayoutConstraint {
    func activate() {
        isActive =  true
    }
}
#endif

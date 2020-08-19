//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public protocol TabBarViewControllerDelegate: AnyObject {
    func tabBar(_ controller: TabBarViewController, didSelect tab: TabBarItem)
    func tabBar(_ controller: TabBarViewController, didConsecutivelySelect tab: TabBarItem)
}

public extension TabBarViewControllerDelegate {
    func tabBar(_ controller: TabBarViewController, didSelect tab: TabBarItem) {}
    func tabBar(_ controller: TabBarViewController, didConsecutivelySelect tab: TabBarItem) {}
}

public final class TabBarViewController: UIViewController {
    public enum ChildLayout {
        case barPinned
        case fullHeight
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
        layout: ChildLayout = .barPinned,
        tabBarView: TabBarViewable,
        tabs: [TabBarItem] = []
    ) {
        self.tabs = tabs
        self.layout = layout
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
        case .barPinned:
            containerView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor).isActive = true
        case .fullHeight:
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.delegate = self
        NSLayoutConstraint.activate([
            tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

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

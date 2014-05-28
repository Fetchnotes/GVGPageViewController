//
//  GVGPageViewController.h
//  ForgeModule
//
//  Created by Giles Van Gruisen on 5/27/14.
//  Copyright (c) 2014 Trigger Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GVGPageViewControllerDelegate;
@protocol GVGPageViewControllerDataSource;

enum {
    GVGPageViewControllerDirectionBackward = 0,
    GVGPageViewControllerDirectionForward = 1
};
typedef NSInteger GVGPageViewControllerDirection;

@interface GVGPageViewController : UIViewController <UIScrollViewDelegate>

// Main view is a scroll view with paging enabled
@property (nonatomic, strong) UIScrollView *view;

@property (nonatomic, strong) id<GVGPageViewControllerDelegate> delegate;
@property (nonatomic, strong) id<GVGPageViewControllerDataSource> dataSource;

// Current view controller
@property (nonatomic, strong) UIViewController *viewController;

// Previous view controller
@property (nonatomic, strong) UIViewController *previousViewController;

// Next view controller
@property (nonatomic, strong) UIViewController *nextViewController;

// Call to set initial view controller or to programmatically change the current view controller (optionally animated with direction)
- (void)setViewController:(UIViewController *)viewController direction:(GVGPageViewControllerDirection)direction animated:(BOOL)animated;

- (id)initWithFrame:(CGRect)frame;

@end

// Tells delegate when certain actions happen on the page view controller
@protocol GVGPageViewControllerDelegate <NSObject>

@optional

// Called when user begins scrolling gesture, doesn't guarantee a transition will occur
- (void)pageViewController:(GVGPageViewController *)pageViewController mightTransitionToViewController:(UIViewController *)viewController;

// Called while user is scrolling, knows nothing about either view controller, only position
- (void)pageViewController:(GVGPageViewController *)pageViewController didScroll:(UIScrollView *)scrollView;

// Called when user end scrolling gesture, guarantees a transition will occur
- (void)pageViewController:(GVGPageViewController *)pageViewController willTransitionToViewController:(UIViewController *)viewController;

// Called when a transition has completed
- (void)pageViewController:(GVGPageViewController *)pageViewController didTransitionToViewController:(UIViewController *)viewController;

@end

// Data source determines which view controllers should be displayed
@protocol GVGPageViewControllerDataSource <NSObject>

@required

// Called to determine the next view controller
- (UIViewController *)pageViewController:(GVGPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

// Called to determine the previous view controller
- (UIViewController *)pageViewController:(GVGPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end

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

@interface GVGPageViewController : UIViewController <UIScrollViewDelegate>

// Main view is a scroll view with paging enabled
@property (nonatomic, strong) UIScrollView *view;

@property (nonatomic, strong) id<GVGPageViewControllerDelegate> delegate;
@property (nonatomic, strong) id<GVGPageViewControllerDataSource> dataSource;

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

@end

// Data source determines which view controllers are included
@protocol GVGPageViewControllerDataSource <NSObject>

@required

@property (nonatomic, strong) NSMutableArray *viewControllers;

// Called when swiping right for the next view controller
- (UIViewController *)pageViewController:(GVGPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

// Called when swiping left for the previous view controller
- (UIViewController *)pageViewController:(GVGPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end

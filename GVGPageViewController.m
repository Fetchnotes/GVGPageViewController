//
//  GVGPageViewController.m
//  ForgeModule
//
//  Created by Giles Van Gruisen on 5/27/14.
//  Copyright (c) 2014 Trigger Corp. All rights reserved.
//

#import "GVGPageViewController.h"

@interface GVGPageViewController ()

@end

@implementation GVGPageViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view = [[UIScrollView alloc] initWithFrame:frame];
        self.view.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        self.view.contentOffset = CGPointMake(320, 0);
        self.view.showsHorizontalScrollIndicator = false;
        self.view.showsVerticalScrollIndicator = false;
        self.view.pagingEnabled = YES;
        self.view.delegate = self;
        self.view.bounces = false;
    }
    return self;
}

#pragma mark setViewController: direction: animated:

- (void)setViewController:(UIViewController *)viewController direction:(GVGPageViewControllerDirection)direction animated:(BOOL)animated
{
    if (animated) {

        // Depending on direct, we must set either previous or next view controller and animate the content offset
        switch (direction) {

            case GVGPageViewControllerDirectionBackward: {

                self.previousViewController = viewController;

                [UIView animateWithDuration:0.5f animations: ^(void) {
                    CGPoint offset = self.view.contentOffset;
                    offset.x -= self.view.frame.size.width;
                    self.view.contentOffset = offset;
                } completion: ^(BOOL finished) {
                    self.viewController = viewController;
                }];
                break;
            }

            case GVGPageViewControllerDirectionForward: {

                self.nextViewController = viewController;

                [UIView animateWithDuration:0.5f animations: ^(void) {
                    CGPoint offset = self.view.contentOffset;
                    offset.x -= self.view.frame.size.width;
                    self.view.contentOffset = offset;
                } completion: ^(BOOL finished) {
                    self.viewController = viewController;
                }];
                break;
            }

        }
    } else {
        self.viewController = viewController;
    }
}

#pragma mark setViewController

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;

    [self addViewController:self.viewController atIndex:1];
    [self setSurroundingViewControllers];
}

- (void)setPreviousViewController:(UIViewController *)previousViewController
{
    _previousViewController = previousViewController;
    [self addViewController:self.previousViewController atIndex:0];
}

- (void)setNextViewController:(UIViewController *)nextViewController
{
    _nextViewController = nextViewController;
    [self addViewController:self.nextViewController atIndex:2];
}

- (void)addViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    [self.view addSubview:viewController.view];
    CGRect frame = self.view.frame;
    frame.origin.x = 320 * index;
    viewController.view.frame = frame;
    [viewController didMoveToParentViewController:self];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(pageViewController:didScroll:)]) {
        [self.delegate pageViewController:self didScroll:self.view];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = self.view.contentOffset.x;

    id newPrevious = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.previousViewController];
    id newNext = [self.dataSource pageViewController:self viewControllerAfterViewController:self.nextViewController];

    if (offsetX == 0 && newPrevious) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        CGRect frame = self.previousViewController.view.frame;
        frame.origin.x = 320;
        self.previousViewController.view.frame = frame;
        [self.view addSubview:self.previousViewController.view];

        self.view.contentOffset = CGPointMake(320, 0);

        self.viewController = self.previousViewController;

        self.previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.viewController];
    } else if (offsetX == 640 && newNext) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        CGRect frame = self.nextViewController.view.frame;
        frame.origin.x = 320;
        self.nextViewController.view.frame = frame;
        [self.view addSubview:self.nextViewController.view];

        self.view.contentOffset = CGPointMake(320, 0);

        self.viewController = self.nextViewController;

        self.nextViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:self.viewController];
    }
}

#pragma mark Factory

- (void)setSurroundingViewControllers
{
    self.previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.viewController];
    self.nextViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:self.viewController];
}

@end

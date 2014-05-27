# GVGPageViewController

Sliding page view controller implementation with better delegate methods than Apple's UIPageViewController.

## What's wrong with UIPageViewController?

UIPageViewController could be really useful for creating interfaces like the iOS springboard but unfortunately the API is not very flexible and UIPageViewControllerDelegate is not very useful for applicatoins like this. I've been using the API for a number of a different projects lately and quickly become fed up, mostly with the methods provided in UIPageViewControllerDelegate. I tried hacking around, but every implementation was still too easy to break.

UIPageViewController was originally built for page flipping a la iBooks, and the API certainly reflects that. It wasn't until iOS 6 that Apple decided to expand the breadth of UIPageViewController to allow for use cases more along the lines of Springboard, but in order to keep backwards compatibility and maintain the iBooks use case, they had to do some weird things.

Because sliding pages were a bit of an afterthought, implementing anything past a very basic UIPageViewController is unnecessarily complicated. It's worth noting the facing pages (iPad, two book pages side by side) requirement of iBooks because, as a result, UIPageViewControllerDelegate methods are passed an array of view controllers, instead of a single view controller. However, if you're using it like Springboard, that array will only ever contain one view controller. I'm not worried about facing pages, so GVGPageViewControllerDelegate will return not an array but rather an instance of UIViewController.

## How to make it better

Particularly, I'd find the API infinitely more valuable if I were able to know when a transition was about to occur. UIPageViewControllerDelegate provides `– pageViewController:willTransitionToViewControllers:` which seems like exactly what I want. But it's not exactly as the name suggests. The name suggests that it will transition to the view controller provided in the viewController argument. However, this is called when the user begins scrolling and, as such, doesn't account for the fact that a user may cancel the transition before it occurs.

The transition may be cancelled by a number of other user interactions. The user may not swipe far enough to actually transition, or perhaps not fast enough for the distance travelled, or even start swiping in the opposite direction to go to the view controller on the opposite side! There is absolutely no guarantee of a transition occuring when `– pageViewController:willTransitionToViewControllers:` is called.

So I propose splitting this into two separate delegate methods:

`- (void)pageViewController:(GVGPageViewController *)pageViewController mightTransitionToViewController:(UIViewController *)viewController`
`- (void)pageViewController:(GVGPageViewController *)pageViewController willTransitionToViewController:(UIViewController *)viewController`

The first, `pageViewController:mightTransitionToViewController:`, is called when the user begins scrolling and, depending on direction, provides the potentially-pending view controller. This is essentially what UIPageViewControllerDelegate's `pageViewController:willTransitionToViewCotnroller` does, but with a more accurate name.

The second, `pageViewController:willTransitionToViewController:`, is called when the user ends scrolling, just before the transition to the new view controller begins. This tells the delegate that a transition is guaranteed and immintent, and to which view controller it will be transitioning.

**There are definitely other improvements to be made, so I invite to to please open an issue or fork and pull-request as you see fit! :D**

## Not subclassing

I'm deciding to do this from scratch instead of subclassing UIPageViewController. As far as I know, UIPageViewController is based on a UIScrollView with pagingEnabled, and that's exactly what we're going to be doing. Calling these delegate methods is relatively easy because of the flexible nature of UIScrollView. It's always communicating with its delegate, so we can take more advantage of that than UIPageViewController does.


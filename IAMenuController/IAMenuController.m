//
//  IASlideoutMenuController.m
//  IADrawerController
//
//  Created by Mark Adams on 12/16/11.
//  BSD License
//

#import "IAMenuController.h"

@interface IAMenuController ()

@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIBarButtonItem *menuBarButtonItem;

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIView *contentView;

- (void)setupViewControllers;
- (void)setupMenuViewController;
- (void)setupContentViewController;
- (void)setupContentView;

- (void)addPanGestureRecognizer;
- (void)addTapToDismissGestureRecognizer;
- (void)removeTapToDismissGestureRecognizer;

- (CGRect)contentViewFrameForOpenMenu;
- (CGRect)contentViewFrameForClosedMenu;
- (CGRect)contentViewFrameForStaging;
- (void)resizeViewForContentView:(UIView *)view;

@end

#pragma mark -

@implementation IAMenuController

#pragma mark Public Properties
@synthesize contentViewController;

#pragma mark Private Properties
@synthesize menuViewController;
@synthesize menuBarButtonItem;

@synthesize navigationBar;
@synthesize contentView;

#pragma mark - Initialization
- (id)initWithMenuViewController:(UIViewController *)menu contentViewController:(UIViewController *)content barButtonItem:(UIBarButtonItem *)barButtonItem;
{
    NSParameterAssert(menu && content);
    
    self = [super init];
    
    if (!self)
        return nil;
    
    menuViewController = menu;
    contentViewController = content;
    menuBarButtonItem = barButtonItem;
    
    return self;
}

#pragma mark - Getters
- (UIBarButtonItem *)menuBarButtonItem
{
    if (!menuBarButtonItem)
        menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.menuViewController.title style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu:)];

    return menuBarButtonItem;
}

- (UINavigationBar *)navigationBar
{
    if (!navigationBar)
    {
        navigationBar = self.navigationController.navigationBar;
        
        if (!navigationBar)
            navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    }
    
    [navigationBar pushNavigationItem:self.navigationItem animated:NO];
    
    return navigationBar;
}

#pragma mark - Setters
- (void)setContentViewController:(UIViewController *)controller
{
    if (controller == contentViewController)
        return;
    
    UIViewController *oldContent = contentViewController;
    contentViewController = controller;
    
    [self removeTapToDismissGestureRecognizer];
    [oldContent willMoveToParentViewController:nil];
    [oldContent viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        self.contentView.frame = [self contentViewFrameForStaging];
    } completion:^(BOOL finished) {
        [oldContent.view removeFromSuperview];
        [oldContent viewDidDisappear:YES];
        [oldContent removeFromParentViewController];
        
        [self addChildViewController:contentViewController];
        [contentViewController viewWillAppear:YES];
        [self.contentView addSubview:contentViewController.view];
        [self resizeViewForContentView:contentViewController.view];
        [contentViewController didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.22 delay:0.1 options:0 animations:^{
            self.contentView.frame = [self contentViewFrameForClosedMenu];
        } completion:^(BOOL finished) {
            [contentViewController viewDidAppear:YES];
        }];
    }];
}

#pragma mark - UIViewController Rotation Overrides
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.menuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.contentViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.menuViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.contentViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.contentViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - UIViewController Containment Overrides
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return NO;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewControllers];
}

#pragma mark - Child Controller Setup
- (void)setupViewControllers
{
    [self setupContentViewController];
    [self setupMenuViewController];
}

- (void)setupContentViewController
{
    self.navigationItem.title = self.contentViewController.title;
    self.navigationItem.leftBarButtonItem = self.menuBarButtonItem;
    [self addChildViewController:self.contentViewController];
    [self.contentViewController viewWillAppear:NO];
    [self setupContentView];
    [self.contentViewController viewDidAppear:NO];
    [self.contentViewController didMoveToParentViewController:self];
}

- (void)setupContentView
{
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self addPanGestureRecognizer];
    [self.contentView addSubview:self.navigationBar];
    [self.contentView addSubview:self.contentViewController.view];
    [self resizeViewForContentView:self.contentViewController.view];
    [self.view addSubview:self.contentView];
    
    self.contentView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(-4.0f, 0.0f);
    self.contentView.layer.shadowOpacity = 0.75f;
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.frame].CGPath;
    self.contentView.layer.shadowRadius = 4.0f;
}

- (void)setupMenuViewController
{
    [self addChildViewController:self.menuViewController];
    self.menuViewController.view.frame = self.view.bounds;
    [self.view insertSubview:self.menuViewController.view belowSubview:self.contentView];
    [self.menuViewController didMoveToParentViewController:self];
}

#pragma mark - Gesture Management
- (void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.contentView addGestureRecognizer:pan];
}

- (void)addTapToDismissGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)removeTapToDismissGestureRecognizer
{
    for (UIGestureRecognizer *recognizer in self.contentView.gestureRecognizers)
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]])
            [self.contentView removeGestureRecognizer:recognizer];
}

#pragma mark - Menu Presentation
- (void)showMenu:(UIBarButtonItem *)sender
{
    [self.menuViewController viewWillAppear:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = [self contentViewFrameForOpenMenu];
    } completion:^(BOOL finished) {
        [self.menuViewController viewDidAppear:YES];
        [self addTapToDismissGestureRecognizer];
    }];
}

- (void)hideMenu:(UIGestureRecognizer *)gesture
{
    [self.menuViewController viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = [self contentViewFrameForClosedMenu];
    }completion:^(BOOL finished) {
        [self.menuViewController viewDidDisappear:YES];
        [self removeTapToDismissGestureRecognizer];
    }];
}

#pragma mark - Content View Presentation


#pragma mark - Pan Gesture Support
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.contentView];
    CGPoint velocity = [pan velocityInView:self.contentView];
    
    CGFloat minimumX = 0.0f;
    CGFloat maximumX = 276.0f;
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        if (translation.x < minimumX)
            return;
        
        [self.menuViewController viewWillAppear:YES];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGRect currentFrame = self.contentView.frame;
        CGFloat newX = currentFrame.origin.x + translation.x;
        
        if (newX < minimumX || newX > maximumX)
            return;
        
        currentFrame.origin.x = currentFrame.origin.x + translation.x;
        self.contentView.frame = currentFrame;
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        CGFloat finalX = self.contentView.frame.origin.x + (0.55 * velocity.x);
        
        BOOL shouldBounce = NO;
        
        if (finalX < minimumX || finalX > maximumX)
            shouldBounce = YES;

        if (finalX >= CGRectGetMidX(self.view.frame))
            finalX = maximumX;
        else
        {
            finalX = minimumX;
            [self.menuViewController viewWillDisappear:YES];
        }
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGFloat bounceX;
            
            if (finalX == minimumX)
                bounceX = minimumX - 10.0f;
            else
                bounceX = maximumX + 10.0f;
            
            CGRect frame = self.contentView.frame;
            frame.origin.x = (shouldBounce) ? bounceX : finalX;
            self.contentView.frame = frame;
        } completion:^(BOOL finished) {
            
            if (shouldBounce)
            {
                [UIView animateWithDuration:0.07 animations:^{
                    CGRect frame = self.contentView.frame;
                    frame.origin.x = finalX;
                    self.contentView.frame = frame;
                }];
            }
            
            if (finalX == maximumX)
            {
                [self.menuViewController viewDidAppear:YES];
                [self addTapToDismissGestureRecognizer];
            }
            else if (finalX == 0.0f)
            {
                [self.menuViewController viewDidDisappear:YES];
                [self removeTapToDismissGestureRecognizer];
            }
        }];
    }
    
    [pan setTranslation:CGPointZero inView:self.contentView];
}

#pragma mark - Frame Calculation
- (CGRect)contentViewFrameForOpenMenu
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = 276.0f;
    
    return frame;
}
     
- (CGRect)contentViewFrameForClosedMenu
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = 0.0f;
    
    return frame;
}

- (CGRect)contentViewFrameForStaging
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = CGRectGetMaxX(self.view.frame) + 44.0f;
    
    return frame;
}

- (void)resizeViewForContentView:(UIView *)view
{
    view.frame = CGRectMake(0.0f, 44.0f, 320.0f, 416.0f);
}

@end







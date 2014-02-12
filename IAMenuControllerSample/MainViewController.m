//
//  MainViewController.m
//  IAMenuController
//
//  Created by Mark Adams on 12/9/11.
//  MIT License
//

#import "MainViewController.h"
#import "IAMenuController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *toggleMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.menuController action:@selector(toggleMenu)];
    self.navigationItem.leftBarButtonItem = toggleMenuButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end

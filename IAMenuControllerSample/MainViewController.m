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

@end

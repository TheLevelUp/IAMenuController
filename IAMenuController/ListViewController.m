//
//  ListViewController.m
//  IADrawerController
//
//  Created by Mark Adams on 12/9/11.
//  BSD License
//

#import "ListViewController.h"
#import "IAMenuController.h"
#import "MainViewController.h"

@interface NSArray (RandomObject)

- (id)randomObject;

@end

#pragma mark -

@implementation NSArray (RandomObject)

- (id)randomObject
{
    NSUInteger randomInteger = arc4random() % self.count;
    return [self objectAtIndex:randomInteger];
}

@end

#pragma mark -

@interface ListViewController ()

@property (nonatomic, strong) NSArray *possibleColors;

@end

#pragma mark -

@implementation ListViewController

@synthesize possibleColors;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.possibleColors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor cyanColor], [UIColor greenColor], [UIColor lightGrayColor], [UIColor magentaColor], [UIColor brownColor], [UIColor orangeColor], nil];
}

- (IAMenuController *)slideoutMenuController
{
    if ([self.parentViewController isKindOfClass:[IAMenuController class]])
        return (IAMenuController *)self.parentViewController;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mvc.view.backgroundColor = [self.possibleColors randomObject];
    self.slideoutMenuController.contentViewController = mvc;
}

@end

//
//  UIViewController+NavigationBar.m
//  zhoujr
//
//  Created by zhoujr on 15/8/24.
//  Copyright (c) 2015年 Topvogues. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>

static char g_NavigationBarKey = 0;

@implementation UIViewController (NavigationBar)

- (NSMutableDictionary *)navigationBarStateDictionary
{
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &g_NavigationBarKey);
    if (!operations)
    {
        operations = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &g_NavigationBarKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return operations;
}

- (void)setNavigationBarTransparent:(BOOL)transparent
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (navigationBar)
    {
        NSMutableDictionary *navigationBarStateDictionary = [self navigationBarStateDictionary];
        if (transparent)
        {
            UIImage *backgroundImage = [navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
            if (backgroundImage)
            {
                navigationBarStateDictionary[@"background"] = backgroundImage;
            }
            
            UIImage *shadowImage = navigationBar.shadowImage;
            if (shadowImage)
            {
                navigationBarStateDictionary[@"shadow"] = shadowImage;
            }
            
            UIImage *transparentImage = [[UIImage alloc] init];
            [navigationBar setBackgroundImage:transparentImage forBarMetrics:UIBarMetricsDefault];
            navigationBar.shadowImage = transparentImage;
        }
        else
        {
            [navigationBar setBackgroundImage:navigationBarStateDictionary[@"background"] forBarMetrics:UIBarMetricsDefault];
            navigationBar.shadowImage = navigationBarStateDictionary[@"shadow"];
        }
    }
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    UINavigationController *navigationController = self.navigationController;
    if (navigationController)
    {
        NSMutableDictionary *navigationBarStateDictionary = [self navigationBarStateDictionary];
        if (hidden)
        {
            navigationBarStateDictionary[@"hidden"] = @(navigationController.navigationBarHidden);
            [navigationController setNavigationBarHidden:YES animated:YES];
        }
        else
        {
            [navigationController setNavigationBarHidden:[navigationBarStateDictionary[@"hidden"] boolValue] animated:YES];
        }
    }
}

@end

//
//  ViewController.m
//  JSPatchDemo
//
//  Created by 檀邹 on 2018/7/8.
//  Copyright © 2018年 Tanz. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end


static void donotChangeTitle(id slf, SEL sel) {
    NSLog(@"-------class_replaceMethod-------");
}

static void setBlackBackground(id slf, SEL sel) {
    UIViewController *vc = (UIViewController *)slf;
    vc.view.backgroundColor = [UIColor blackColor];
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"firstPage";
    
}

- (void)changeTitle {
    self.title = @"changeTitle";
}

//为注册的新类 添加方法
- (IBAction)registerClass:(id)sender {
    
    Class superCls = NSClassFromString(@"ViewController");
    Class cls = objc_allocateClassPair(superCls, "JPObject", 0);
    objc_registerClassPair(cls);
    
    SEL selector = NSSelectorFromString(@"setRedBackground");
    class_addMethod(cls, selector, setBlackBackground, "");
    
    id newVC = [[cls alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}

//替换某个类的方法为新的实现
- (IBAction)replaceMethod:(id)sender {

    Class sourceClass = NSClassFromString(@"ViewController");
    id sourceControler = [[sourceClass alloc] init];
    
    SEL changeTitle = NSSelectorFromString(@"changeTitle");
    
    class_replaceMethod(sourceClass, changeTitle, donotChangeTitle, "");
    
    [sourceControler performSelector:changeTitle];
    
}


//类名 方法名 映射 相应的类和方法
- (IBAction)pushSecondPage:(id)sender {
    
//    生成类
    Class destinationClass = NSClassFromString(@"SecondViewController");
    id viewController = [[destinationClass alloc] init];
    
//    生成方法
    SEL selector = NSSelectorFromString(@"changeBackgroundColor");
    [viewController performSelector:selector];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

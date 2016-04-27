//
//  ViewController.m
//  Custom AlertView
//
//  Created by 顾昕琪 on 16/4/27.
//  Copyright © 2016年 GuYi. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()
{
    UIAlertController *_alert;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertViewWithChange:(BOOL)isChange {
    
    _alert = [UIAlertController alertControllerWithTitle:@"title"
                                                 message:@"this is a alert"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"default"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"destructive"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }];
    
    [_alert addAction:defaultAction];
    [_alert addAction:cancelAction];
    [_alert addAction:destructiveAction];
    
    if (isChange == YES) {
      [self runtimeProperty];
    }

    [self presentViewController:_alert animated:YES completion:nil];
}

- (IBAction)presentOriginalTap:(id)sender {
    
    [self showAlertViewWithChange:NO];
   
}

- (IBAction)prensetCustomTap:(id)sender {
    
    //    [self runtimeMethod];
    [self runtimeProperty];
    [self showAlertViewWithChange:YES];
}

/**
 *  获取UIAlertController方法名
 */
- (void)runtimeMethod{
    unsigned int count = 0;
    Method *alertMethod = class_copyMethodList([UIAlertController class], &count);
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(alertMethod[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        NSLog(@"methodName ============= %@",methodName);
    }
}


/**
 *  获取UIAlertController属性名
 */
- (void)runtimeProperty {
    unsigned int count = 0;
    Ivar *property = class_copyIvarList([UIAlertController class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = property[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        NSLog(@"%s ================ %s",name,type);
    }

    Ivar message = property[2];
    
/**
 *  字体修改
 */
    UIFont *big = [UIFont systemFontOfSize:25];
    UIFont *small = [UIFont systemFontOfSize:18];
    UIColor *red = [UIColor redColor];
    UIColor *blue = [UIColor blueColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"hello world" attributes:@{NSFontAttributeName:big,
NSForegroundColorAttributeName:red}];
    [str setAttributes:@{NSFontAttributeName:small} range:NSMakeRange(0, 2)];
    [str setAttributes:@{NSForegroundColorAttributeName:blue} range:NSMakeRange(0, 4)];
    
//最后把message内容替换掉
    object_setIvar(_alert, message, str);
}


@end

//
//  CompareJSPatchController.m
//  JSPatchDemo
//
//  Created by 檀邹 on 2018/7/10.
//  Copyright © 2018年 Tanz. All rights reserved.
//

#import "CompareJSPatchController.h"

@interface CompareJSPatchController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;


@end

@implementation CompareJSPatchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataSource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self dataSource][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[self dataSource][indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"click btn %@",[alertView buttonTitleAtIndex:buttonIndex]);
}


- (NSArray *)dataSource {
    
    if (_data == nil) {
        _data = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [_data addObject:[NSString stringWithFormat:@"cell from js %d",i]];
        }
    }
    return _data;
}


@end

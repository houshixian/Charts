//
//  ViewController.m
//  ChartLib
//
//  Created by ChinaMonkey on 16/4/28.
//  Copyright © 2016年 ChinaMonkey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *mDataSource;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mDataSource = [NSMutableArray array];
    [mDataSource addObject:@"马表盘"];
    [mDataSource addObject:@"线"];
    [mDataSource addObject:@"线和柱形图"];
    [mDataSource addObject:@"柱形图"];
    
    [mTableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:mDataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"One" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"Two" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"Three" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"Four" sender:nil];
            break;
        case 4:
            break;
        case 5:
            
        default:
            break;
    }
}

@end

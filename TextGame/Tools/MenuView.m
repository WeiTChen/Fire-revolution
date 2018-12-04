//
//  MenuView.m
//  recruit
//
//  Created by 智齿 on 16/8/10.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "MenuView.h"


@interface MenuView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) void (^showBlock)(NSDictionary *cellDic);

@property (nonatomic,assign) NSUInteger cellCount;

@end

@implementation MenuView

- (void)addMenuViewWithFrame:(CGRect )frame cellClass:(Class)cellClass cellCount:(NSUInteger)cellCount showBlock:(void (^)(NSDictionary *cellDic))showBlock animation:(bool)animation
{
    
    float height = frame.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iden"];
    tableView.delegate = self;
    tableView.dataSource = self;
    _showBlock = showBlock;
    _cellCount = cellCount;
    if (animation)
    {
        tableView.frame = CGRectMake(0, 0, frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tableFrame = tableView.frame;
            tableFrame.size.height = height;
            tableView.frame = tableFrame;
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_showBlock)
    {
        _showBlock(@{@"cell":cell,@"indexPath":indexPath});
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellSelectBlock)
    {
        _cellSelectBlock(@{@"indexPath":indexPath});
    }
}

@end

//
//  ViewController.m
//  TextGame
//
//  Created by william on 2018/1/11.
//  Copyright © 2018年 william. All rights reserved.
//

#define WAIT_TIME 2.5

#import "ViewController.h"
#import "ContentModel.h"
#import "ButtonTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//
@property (nonatomic,strong) UITableView *tableView;

//addDataAry
@property (nonatomic,strong) NSMutableArray *addAry;

//metaDataAry
@property (nonatomic,strong) NSMutableArray *textAry;

//key
@property (nonatomic,strong) NSMutableDictionary *hashDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.view addSubview:imgv];
    imgv.userInteractionEnabled = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-144) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iden"];
    [self.tableView registerClass:[ButtonTableViewCell class] forCellReuseIdentifier:@"btn"];
    self.tableView.estimatedRowHeight = 50.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _textAry = [NSMutableArray array];
    _addAry = [NSMutableArray array];
    _hashDic = [NSMutableDictionary dictionary];
    [self setup];
    [self autoAdd];
    
}

- (void)setup{
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataAry = [str componentsSeparatedByString:@"\n"];
    NSMutableArray *bufferAry = [NSMutableArray array];
    NSString *hashKey = @"";
    bool open = NO;
    for (NSString *str in dataAry) {
        if (str.length==0) {
            continue;
        }
        if ([str rangeOfString:@"keyStart"].length>0) {
            open = YES;
            hashKey = [str substringFromIndex:[str rangeOfString:@"="].location+1];
        }
        else if ([str rangeOfString:@"keyEnd"].length>0) {
            [self.hashDic setValue:bufferAry forKey:hashKey];
            open = NO;
            bufferAry = [NSMutableArray array];
            hashKey = @"";
        }
        else{
            ContentModel *model = [[ContentModel alloc] init];
            if ([str rangeOfString:@"SEL"].length>0) {
                NSArray *btnDataAry = [str componentsSeparatedByString:@"&&"];
                NSMutableArray *modelStrAry = [NSMutableArray array];
                NSMutableArray *hashAry = [NSMutableArray array];
                for (NSString *btnDataStr in btnDataAry) {
                    NSString *formatStr = [btnDataStr stringByReplacingOccurrencesOfString:@"SEL:" withString:@""];
                    NSRange range = [formatStr rangeOfString:@"{{"];
                    NSString *text = [formatStr substringToIndex:range.location];
                    NSString *hash = [[[formatStr stringByReplacingOccurrencesOfString:text withString:@""] stringByReplacingOccurrencesOfString:@"{{" withString:@""] stringByReplacingOccurrencesOfString:@"}}" withString:@""];
                    [modelStrAry addObject:text];
                    [hashAry addObject:hash];
                }
                model.textAry = modelStrAry;
                model.selAry = hashAry;
            }else{
                NSString *text = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([text rangeOfString:@"A:"].length>0 || [text rangeOfString:@"B:"].length>0 || [text rangeOfString:@"C:"].length>0) {
                    model.text = [text substringFromIndex:2];
                }else{
                    model.text = text;
                }
                model.color = [text rangeOfString:@"A:"].length>0?[UIColor greenColor]:[text rangeOfString:@"B:"].length>0?[UIColor redColor]:[text rangeOfString:@"C:"].length>0?[UIColor yellowColor]:[UIColor orangeColor];
            }
            
            if (open) {
                [bufferAry addObject:model];
                continue;
            }
            [self.textAry addObject:model];
        }
    }
    
}

- (void)autoAdd{
    if (self.addAry.count >= self.textAry.count) {
        //故事完结
        return;
    }
    ContentModel *model = self.textAry[self.addAry.count];
    [self addTextFromMe:model];
    if (model.text.length>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(WAIT_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self autoAdd];
        });
    }
    
}

- (void)addTextFromMe:(ContentModel *)model{
    [self.addAry addObject:model];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.addAry.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentModel *model = self.addAry[indexPath.section];
    if (model.textAry.count>0) {
        //表示这是一个选择节点而不是文字节点
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"btn" forIndexPath:indexPath];
        [cell.leftButton setTitle:model.textAry[0] forState:UIControlStateNormal];
        [cell.rightButton setTitle:model.textAry[1] forState:UIControlStateNormal];
        cell.leftButton.userInteractionEnabled = cell.rightButton.userInteractionEnabled = NO;
        if ([model.selectIndex isEqualToString:@"0"]) {
            [cell.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if ([model.selectIndex isEqualToString:@"1"]){
            [cell.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [cell.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.leftButton.userInteractionEnabled = cell.rightButton.userInteractionEnabled = YES;
        }
        
        __weak typeof(self) weakSelf = self;
        cell.selBlock = ^(NSInteger index) {
            model.selectIndex = [NSString stringWithFormat:@"%ld",index];
            NSArray *newAry = self.hashDic[model.selAry[index]];
            for (int i = 0; i < newAry.count; i++) {
                id obj = newAry[i];
                [weakSelf.textAry insertObject:obj atIndex:indexPath.section+1+i];
            }
            [weakSelf autoAdd];
        };
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.numberOfLines = 0;
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
        //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
        CGFloat emptylen = 34;
        paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
        paraStyle01.lineSpacing = 7.0f;//行间距
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:model.text attributes:@{NSParagraphStyleAttributeName:paraStyle01,NSForegroundColorAttributeName:model.color}];
        
        cell.textLabel.attributedText = attrText;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //透明度
    if (indexPath.section == self.addAry.count-1) {
        cell.alpha = 0;
        [UIView beginAnimations:@"rotaion" context:NULL];
        [UIView setAnimationDuration:0.8];
        cell.alpha = 1;
        [UIView commitAnimations];
    }
}


@end

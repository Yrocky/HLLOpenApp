//
//  HLLDataSource.m
//  HLLOpenURL
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import "HLLDataSource.h"
#import "HLLOpenClass.h"
#import "Tool.h"


@interface HLLDataSource ()

@property (nonatomic ,strong) NSMutableArray * openArray;

@property (nonatomic ,strong) NSMutableDictionary * openDictionary;

@property (nonatomic, copy) NSString * cellIdentifier;

@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end
@implementation HLLDataSource


char pinyinFirstLeter(unsigned short hanzi)
{
    int index = hanzi - HANZI_START;
    if (index >= 0 && index <= HANZI_COUNT)
    {
        return firstLetterArray[index];
    }
    else
    {
        return '#';
    }
}

- (id) init{
    
    return nil;
}

- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
          configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];// 这里使用copy而不是直接将block进行赋值，
 
//        [self _loadDataFromPlist];
    }
    return self;
}

- (void)dataSource_didFinishLoadDataHandle:(Compeltion)handle{
 
    [self _loadDataFromPlist];
    if (handle) {
        handle(YES);
    }
}
- (void) _loadDataFromPlist{

    NSString * plist = [[NSBundle mainBundle] pathForResource:@"schemes-1.0.0" ofType:@"plist"];
    NSDictionary * ipas = [NSDictionary dictionaryWithContentsOfFile:plist];
    
    NSArray * plistArray = [ipas objectForKey:@"ipas"];
    
    self.openArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [plistArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL *stop) {
        
        HLLOpenClass * openClass = [HLLOpenClass itemWithDict:dict];
        
        [self _currentPhoneInstanAPPWithOpenClass:openClass];
    }];
    
    [self _sortOpenArrayWithLetterOrder];
    
    NSLog(@"dict:%@",_openDictionary);
}

/**
 *  获取当前手机上安装的app
 */
- (void) _currentPhoneInstanAPPWithOpenClass:(HLLOpenClass *)openClass{
    
    NSArray * schemes = openClass.schemes;
    
    [schemes enumerateObjectsUsingBlock:^(NSString * item, NSUInteger idx, BOOL *stop) {
        
        NSString * schem;
        if (![item hasSuffix:@"://"]) {
            schem = [NSString stringWithFormat:@"%@://",item];
        }else{
            schem = item;
        }
        NSURL * url = [NSURL URLWithString:schem];
        
        BOOL canOpenWithURL = [[UIApplication sharedApplication] canOpenURL:url];
        
        if (canOpenWithURL) {
            
            [self.openArray addObject:openClass];
            *stop = YES;
        }
    }];
}

- (void) _sortOpenArrayWithLetterOrder{
    
    _openDictionary = [NSMutableDictionary dictionary];
    
    for (HLLOpenClass * openClass in self.openArray) {
        
        NSString * name = openClass.name;
        
        NSString * strFirLetter = [self _letterOrderWithString:name];
        
        if ([[_openDictionary allKeys] containsObject:strFirLetter]) {
            [[_openDictionary objectForKey:strFirLetter] addObject:openClass];
        }else{
            NSMutableArray * tempArray = [NSMutableArray array];
            [tempArray addObject:openClass];
            [_openDictionary setObject:tempArray forKey:strFirLetter];
        }
    }
}

/**
 *  根据英文字母序对汉字和字母进行归类
 */
- (NSString *) _letterOrderWithString:(NSString *)string{
    
    //判断首字符是否为字母
    NSString * regex = @"[A-Za-z]+";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSString * initialStr = [string length]?[string  substringToIndex:1]:@"";
    
    NSString * strFirLetter;
    if ([predicate evaluateWithObject:initialStr])
    {
        //首字母大写
        strFirLetter = [initialStr capitalizedString];
    }
    else
    {
        if(![string isEqualToString:@""])
        {
            strFirLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLeter(([string characterAtIndex:0]))]uppercaseString];
        }else{
            strFirLetter = @"#";
        }
    }
    return strFirLetter;
}

//构建数组排序方法SEL
//NSInteger cmp(id, id, void *);
//倒序排
NSInteger cmp(NSString * a, NSString* b, void * p)
{
    if([a compare:b] != 1){
        return NSOrderedDescending;//(1)
    }else
        return  NSOrderedAscending;//(-1)
}
#pragma mark - publice

- (NSArray *) dataSource_sectionsWithSortAllKeysForOpenDictionary{

    NSArray * allKeys = [self.openDictionary allKeys];
    NSArray * tempArr = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 compare:obj2] != 1) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0;i < [tempArr count];i++)
    {
        NSString *keyStr = [tempArr objectAtIndex:i];
        
        if ([keyStr isEqualToString:@"#"])
        {
            [array addObject:keyStr];
        }
        else
        {
            [array insertObject:keyStr atIndex:0];
        }
    }
    
    return array;
}
- (NSArray *) dataSource_rowsAtOneSection:(NSInteger)section{

    NSArray * allKeys = [self dataSource_sectionsWithSortAllKeysForOpenDictionary];
    
    NSString * key = [allKeys objectAtIndex:section];
    
    NSArray * rows = [self.openDictionary objectForKey:key];
    
    return rows;
}

- (NSString *) dataSource_titleForHeaderInSection:(NSInteger)section{

    NSArray * allKeys = [self dataSource_sectionsWithSortAllKeysForOpenDictionary];
 
    return [allKeys objectAtIndex:section];
}

- (id)itemWithIndexPath:(NSIndexPath *)indexPath{

    NSArray * rows = [self dataSource_rowsAtOneSection:indexPath.section];
    
    HLLOpenClass * openClass = rows[indexPath.row];
    
    return openClass;
}
#pragma mark - dataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSArray * allKeys = [self dataSource_sectionsWithSortAllKeysForOpenDictionary];
    return [allKeys count];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * rows = [self dataSource_rowsAtOneSection:section];
    return rows.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];

    id item = [self itemWithIndexPath:indexPath];
    
    self.configureCellBlock(cell,item);
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString * title = [self dataSource_titleForHeaderInSection:section];
    return title;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = [UIColor whiteColor];
    NSArray * allKeys = [self dataSource_sectionsWithSortAllKeysForOpenDictionary];
    return allKeys;
}

@end

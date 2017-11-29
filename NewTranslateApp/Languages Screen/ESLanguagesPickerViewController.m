//
//  ESLanguagesPickerViewController.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESLanguagesPickerViewController.h"
#import "Language.h"
#import "ESDataManager.h"
#import "ESTranslationManager.h"

@interface ESLanguagesPickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ESLanguagesPickerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    [self setupObjects];
}

#pragma mark - Actions

- (void)setupUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addRefreshControl];
}

- (void)addRefreshControl
{
    if (!self.refreshControl)
    {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.tableView addSubview:self.refreshControl];
    }
    [self.refreshControl addTarget:self action:@selector(refreshBooks:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.layer.zPosition = -1;
}

- (void)setupObjects {
    
    if (!self.dataArray) {
        
        self.dataArray = [ESDataManager allLanguages];
    }
    [self loadData];
}

- (void)loadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
    });
    
    __weak typeof(self) weakSelf = self;
    [ESTranslationManager languages:^(BOOL success, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.refreshControl endRefreshing];
        });
        weakSelf.dataArray = [ESDataManager allLanguages];
    }];
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)refreshBooks:(UIRefreshControl *)sender {
    
    [self loadData];
}

- (IBAction)done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegates
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"LangCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Language *lang = self.dataArray[indexPath.row];
    cell.textLabel.text = lang.name;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (lang.isCurrent.boolValue) {
        cell.backgroundColor = [UIColor orangeColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Language *lang = self.dataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [ESDataManager setCurrentLanguage:lang completion:^(BOOL success, NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}

@end

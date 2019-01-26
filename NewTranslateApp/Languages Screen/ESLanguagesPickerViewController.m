//
//  ESLanguagesPickerViewController.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 29.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESLanguagesPickerViewController.h"
#import "Language.h"
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
    
    [self addRefreshControl];
}

- (void)addRefreshControl {
    
    if (!self.refreshControl) {
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.tableView addSubview:self.refreshControl];
    }
    [self.refreshControl addTarget:self action:@selector(refreshBooks:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.layer.zPosition = -1;
}

- (void)setupObjects {
    
    if (!self.dataArray) {
        
        self.dataArray = [Language allLanguages];
        [self.tableView reloadData];
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
        
        if (success) {
            
            weakSelf.dataArray = [Language allLanguages];
            [weakSelf.tableView reloadData];

        } else if (error) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }];
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
    [Language setCurrentLanguage:lang completion:^(BOOL success, NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}

@end

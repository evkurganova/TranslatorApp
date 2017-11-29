//
//  ViewController.m
//  NewTranslateApp
//
//  Created by Ekaterina Systerova on 26.11.2017.
//  Copyright © 2017 Ekaterina Systerova. All rights reserved.
//

#import "ESMainViewController.h"
#import "ESRouter.h"
#import "ESTranslationManager.h"
#import "Word.h"
#import "Language.h"
#import "ESDataManager.h"

@interface ESMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pickerBarButton;

@end

@implementation ESMainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    [self setupObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.pickerBarButton.title = [ESDataManager currentLanguage].name;
}

#pragma mark - Actions

- (void)setupUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.textField.delegate = self;
}

- (void)setupObjects {
    
    if (!self.dataArray) {
        
        [self loadData];
    }
}

- (void)loadData {
    
    self.dataArray = [ESDataManager allWords];
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (IBAction)translate:(id)sender {
    
    if (!self.textField.text) {
        return;
    }
    
    [self.textField resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [ESTranslationManager translationForWord:self.textField.text language:[ESDataManager currentLanguage].languageID completion:^(BOOL success, NSError *error) {
        
        [weakSelf loadData];
    }];
}

- (IBAction)showList:(id)sender {
    
    [self.navigationController presentViewController:[ESRouter languagesPicker] animated:YES completion:nil];
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
    
    static NSString *cellIdentifier = @"WordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Word *word = self.dataArray[indexPath.row];
    
    cell.textLabel.text = word.nativeWord;
    cell.detailTextLabel.text = word.translatedWord;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Word *word = self.dataArray[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        [ESDataManager deleteWord:word completion:^(BOOL success, NSError *error) {
            
            if (success) {
                
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf loadData];
            }
        }];
    }
}

#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end

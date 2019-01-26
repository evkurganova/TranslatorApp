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

@interface ESMainViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

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
    
    [self reloadButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadButton) name:kNotificationCurrentLanguageChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)setupUI {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.textField.delegate = self;
    self.searchBar.delegate = self;
}

- (void)setupObjects {
    
    if (!self.dataArray) {
        
        [self loadData];
    }
}

- (void)loadData {
    
    // в поисковой строке что-нибудь введено?
    if (self.searchBar.text && ![self.searchBar.text isEqualToString:@""]) {
        
        self.dataArray = [Word allWordsWithText:self.searchBar.text];
        [self.tableView reloadData];
        
    } else {
        
        self.dataArray = [Word allWords];
        [self.tableView reloadData];
    }
}

- (void)reloadButton {
    
    self.pickerBarButton.title = [NSString stringWithFormat:@"На %@", [Language currentLanguage].name.lowercaseString];
}

- (IBAction)translate:(id)sender {
    
    if (!self.textField.text || [self.textField.text isEqualToString:@""]) {
        return;
    }
    
    [self.textField resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [Word createWord:self.textField.text completion:^(BOOL success, NSError *error) {
        
        [weakSelf loadData];

        [ESTranslationManager translationForWord:self.textField.text language:[Language currentLanguage].languageID completion:^(BOOL success, NSError *error) {
            
            if (success) {
                
                [weakSelf loadData];

            } else if (error) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:okAction];
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }];
}

- (IBAction)showList:(id)sender {
    
    [self.navigationController presentViewController:[ESRouter languagesPicker] animated:YES completion:nil];
}


- (void)keyboardDidShow:(NSNotification *)notification {
    
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    self.tableView.contentInset = UIEdgeInsetsZero;
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
        [Word deleteWord:word completion:^(BOOL success, NSError *error) {
            
            if (success) {
                
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self loadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self loadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self loadData];
}

@end

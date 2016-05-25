#import "IVQGameViewController.h"
#import "AppDelegate.h"
#import "IVQQuestion.h"
#import "IVQGameQuestionTableViewCell.h"
#import <Toast/UIView+Toast.h>
#import <ionicons/IonIcons.h>

@interface IVQGameViewController () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) BOOL gameCompleted;
@property (strong, nonatomic) NSArray *questions;
@property (assign, nonatomic) NSInteger currentQuestionNumber;
@property (assign, nonatomic) NSInteger countNo;
@property (assign, nonatomic) NSInteger countYes;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IVQGameViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.title = @"InterviewQuest";
    UIImage *menuImage = [IonIcons imageWithIcon:ion_ios_more size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonTapped:)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IVQGameQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"questionCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    self.questions = appDelegate.questions;
    self.currentQuestionNumber = 0;
    self.countYes = 0;
    self.countNo = 0;
    self.gameCompleted = NO;
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)pauseButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Quest paused" message:@"Continue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *endGameAction = [UIAlertAction actionWithTitle:@"End quest"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self dismiss];
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK action");
    }];
    [alertController addAction:endGameAction];
    [alertController addAction:continueAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height - 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.questions.count) {
        [self dismiss];
        return;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IVQGameQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    if (indexPath.row == self.questions.count) {
        cell.questionLabelText = @"Done";
    }
    else {
        IVQQuestion *question = (IVQQuestion *)self.questions[indexPath.row];
        cell.questionLabelText = question.title;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Add 1 for our GameOver cell.
    return self.questions.count + 1;
}

@end
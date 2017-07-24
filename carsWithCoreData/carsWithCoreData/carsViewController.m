//
//  carsViewController.m
//  carsWithCoreData
//
//  Created by shfrc101b8 on 2016-12-06.
//  Copyright © 2016 shfrc101b8. All rights reserved.
//

#import "carsViewController.h"
#import "appDelegate.h"

@interface carsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *carMake;
@property (weak, nonatomic) IBOutlet UITextField *carModel;
@property (weak, nonatomic) IBOutlet UITextField *carYear;
@property (strong) NSManagedObjectContext *managedObjectContext;

-(void) initializeCoreData;
@end
@implementation carsViewController
- (IBAction)textFieldDidEndEditing:(UITextField *)textField{
    
    //do stuff
    [textField resignFirstResponder];
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeCoreData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findData:(UIButton *)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Cars" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(carMake = %@)", self.carMake.text];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0){
        self.carMake.text = @"No matches";
    } else {
        matches = objects[0];
        self.carModel.text = [matches valueForKey:@"carModel"];
        self.carYear.text = [matches valueForKey:@"carYear"];
        //self.statusLbl.text = [NSString stringWithFormat:@"%lu matches found", (unsigned long)[objects count]];
    }
}

- (IBAction)saveData:(UIButton *)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newContact;
    
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cars" inManagedObjectContext:context];
    
    [newContact setValue:self.carMake.text forKey:@"carMake"];
    [newContact setValue:self.carModel.text forKey:@"carModel"];
    [newContact setValue:self.carYear.text forKey:@"carYear"];
    
    self.carMake.text = @"";
    self.carModel.text = @"";
    self.carYear.text = @"";
    NSError *error;
    [context save:&error];
    
    self.carMake.text = @"Contact saved";
}

-(void) initializeCoreData{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"carsWithCoreData" withExtension:@"momd"];
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    NSAssert(mom != nil, @"Error initializing MOM");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"carsWithCoreDataModel.sqlite"];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

@end

ExpandAndScrollFullVC
=====================

UITableView can ScrollFull and Expand animation


1.How to use it 

  a. inherit  ExpandAndScrollFullVC
  
  b. if you want to use the Expand animation, you must set the exandAndScrollFulldelegate
  
  c. self.targetTable = your_tableView;
  
  d. write the delegate function
  
2.KeyCode

    self.exandAndScrollFulldelegate = self;

    //middle view
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_Y_NAV_Y_TAB)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor lightGrayColor];
    self.targetTable = _tableView;
    
    [self.view addSubview:_tableView];
    
#pragma mark -- ScrollFullAndFoldableVCDelegate

  - (UIViewController *)getPushVCByIndexPath:(NSIndexPath *)indexPath
  {
      AJSecondLevelVC *vc = [[AJSecondLevelVC alloc] init];
      vc.hidesBottomBarWhenPushed = YES;

     return vc;
  }

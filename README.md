ExpandAndScrollFullVC
=====================

UITableView can ScrollFull and Expand animation

1.What does it do
=====================

  a.UITableview can Full when scroll
  
  b.DidSelect the cell can push into a new view with Expand animation
  
  c.Tabbar add the slider animation
  

2.How to use it 
=====================
  a. inherit  ExpandAndScrollFullVC
  
  b. if you want to use the Expand animation, you must set the exandAndScrollFulldelegate
  
  c. self.targetTable = your_tableView;
  
  d. write the delegate function
  
3.KeyCode
=====================
    self.exandAndScrollFulldelegate = self;

    //middle view
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_Y_NAV_Y_TAB)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor lightGrayColor];
    self.targetTable = _tableView;
    
    [self.view addSubview:_tableView];

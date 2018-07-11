
defineClass('JSPatchViewController', {
            handleBtn: function(sender) {
            var tableViewCtrl = JPTableViewController.alloc().init()
            self.navigationController().pushViewController_animated(tableViewCtrl, YES)
            }
            })

//require("UIButton, UIScreen, UIColor, JSPatchViewController");

defineClass('ViewController', {
            createSubview:function(sender) {
                var tableViewCtrl = require('JPTableViewController').alloc().init()
                self.navigationController().pushViewController_animated(tableViewCtrl, YES)
            },
            
            viewDidLoad:function() {
                self.setTitle('NEW_FUNCTION_PAGE');
                var button =  require('UIButton').buttonWithType(0);
                button.setTitle_forState("newFunction", 0);
//                var red = UIColor.redColor();
                var blue = require('UIColor').blueColor();
                button.setTitleColor_forState(blue, 0);
//                button.setBackgroundColor(red);
                self.view().addSubview(button);
                button.setFrame({x:100, y:500, width:200, height:120});
                button.addTarget_action_forControlEvents(self,"newFunc",1 << 6);
            
                self.getClassName();
            
            
            
//            block
            var block = require('ViewController').getBlock();
            block({version:'5000'});
//            var showMessage = require('ViewController').alloc().init().showMessage();
//            showMessage({'dsadsa'});
            
            },
            
            getClassName:function() {
                console.log(self.class());
                return self.class();
            },
            
            newFunc:function() {
                console.log('new function start');
//            require('JPEngine').addExtensions(['JPBlock']);
            require('ViewController').request(block("void, id", function(ctn) {
                                                    console.log(ctn);
                                                    }));
//                var tableViewCtrl = JSPatchViewController.alloc().init()
//                self.navigationController().pushViewController_animated(tableViewCtrl, YES)
            },
            
            
            
            },{});


//tableView
defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
            
            dataSource: function() {
            var data = self.data();
            if (data) return data;
            var data = [];
            for (var i = 0; i < 20; i ++) {
            data.push("cell from js " + i);
            }
            self.setData(data)
            return data;
            },
            
            
            numberOfSectionsInTableView: function(tableView) {
            return 1;
            },
            
            
            tableView_numberOfRowsInSection: function(tableView, section) {
            return self.dataSource().length;
            },
            
            
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
            if (!cell) {
            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
            }
            cell.textLabel().setText(self.dataSource()[indexPath.row()])
            return cell
            },
            
            
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
            return 60
            },
            
            
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
            alertView.show()
            },
            
            
            alertView_willDismissWithButtonIndex: function(alertView, idx) {
            console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
            }
            })

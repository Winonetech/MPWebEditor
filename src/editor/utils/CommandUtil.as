package editor.utils
{
	
	/**
	 * 
	 * 命令工具，负责命令调用。
	 * 
	 */
	
	
	import cn.mvc.core.NoInstance;
	import cn.mvc.utils.MathUtil;
	
	import editor.commands.*;
	import editor.core.MDConfig;
	import editor.core.MDPresenter;
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.ComponentType;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	import mx.controls.Alert;
	
	import spark.components.RichEditableText;
	
	
	public class CommandUtil extends NoInstance
	{
		
		
		/**
		 * 
		 * 组件内容填充完毕处理。
		 * 
		 * @param $componentId:String 组件ID。
		 * @param $componentCode:String 组件编码。
		 * 
		 */
		
		public static function fillComplete($scope:Object):void
		{
			if ($scope)
			{
				getComponentById($scope.componentId).hasContent = $scope.hasContent;
				vars.canvas.updateComponent(getComponentById($scope.componentId));
			}
			else
				Alert.show("组件参数为空!", "错误：");
		}
		
		
		public static function getSheetBackground($scope:Object):void
		{
			if ($scope)
			{
				edtSheet(config.editingSheet, {"background" : $scope.background});
			}
			else
				Alert.show("页面参数为空!", "错误：");
		}
		
		
		/**
		 * 
		 * 填充背景。
		 * 
		 * @param $sheetId:String 页面ID。
		 * 
		 */
		public static function fillSheetBackground($sheetId:String, $background:String):void
		{
			presenter.execute(new FillSheetBackgroundCommand($sheetId, $background));
		}
		
		/**
		 * 
		 * 填充组件。
		 * 
		 * @param $componentId:String 组件ID。
		 * @param $componentCode:String 组件编码。
		 * 
		 */
		
		public static function fillComponent($componentId:String, $componentCode:String):void
		{
			presenter.execute(new FillContentComand($componentId, $componentCode));
		}
		
		
		/**
		 * 
		 * 传入初始化数据启动。
		 * 
		 * @param $data:Object 传入一个初始化数据，格式为：<br>
		 * {<br>
		 * &nbsp;&nbsp;domain:"http://192.168.7.3:9000",<br>
		 * &nbsp;&nbsp;programId: 3,<br>
		 * &nbsp;&nbsp;layoutId: 1,<br>
		 * &nbsp;&nbsp;programName: "测试",<br>
		 * &nbsp;&nbsp;defaultWidth: "1920",<br>
		 * &nbsp;&nbsp;defaultHeight: "1080"<br>
		 * }
		 * 
		 */
		
		public static function transmitData($data:Object):void
		{
			presenter.execute(new InitProgramCommand($data));
			presenter.execute(new LoadComponentTypesCommand);
			presenter.execute(new LoadLayoutCommand);
			presenter.execute(new InitDataCommand);
			presenter.execute(new ShowViewCommand);
			presenter.execute(new ShowSheetsCommand);
			presenter.execute(new ShowComponentTypesCommand);
			presenter.execute(new AddPageCommand(null, 0, true));
			presenter.execute(new OpenSheetCommand);
		}
		
		
		/**
		 * 
		 * 快捷键删除。
		 * 
		 */
		
		public static function shotcutDel():void
		{
			var stage:* = vars.application.stage;
			if (stage)
			{
				if(!(stage.focus is RichEditableText))
				{
					if(!presenter.executing)
					{
						if (config.selectedComponent)
							delComponent(config.selectedComponent);
						else if (config.selectedSheet)
							delPage(config.selectedSheet as Page);
					}
				}
			}
		}
		
		
		/**
		 * 
		 * 添加组件。
		 * 
		 * @param $sheet:Sheet 要操作的版面，版面包含页面和广告。
		 * @param $componentType:ComponentType 组件类别。
		 * @param $order:uint 顺序。
		 * @param $x:Number (default = 0) X坐标。
		 * @param $y:Number (default = 0) Y坐标。
		 * 
		 */
		
		public static function addComponent($sheet:Sheet, $componentType:ComponentType, $order:uint, $x:Number = 0, $y:Number = 0):void
		{
			if ($sheet && $componentType)
				presenter.execute(new AddComponentCommand($sheet, $componentType, $order, $x, $y));
		}
		
		
		/**
		 * 
		 * 删除组件。
		 * 
		 * @param $component:Component 要删除的组件。
		 * 
		 */
		
		public static function delComponent($component:Component):void
		{
			if ($component)
			{
				presenter.execute(new DelComponentCommand(config.selectedComponent));
//				presenter.execute(new OrdComponentCommand);
			}
		}
		
		
		/**
		 * 
		 * 修改组件顺序。
		 * 
		 * @param $component:Component 要修改顺序的组件。
		 * @param $order:uint 组件的新顺序。
		 * 
		 */
		
		public static function ordComponent($component:Component, $order:int):void
		{
			if (config.editingSheet && $component)
			{
				$order = MathUtil.clamp($order, 0, config.editingSheet.componentsArr.length - 1);
				if ($order != $component.order)
					presenter.execute(new OrdComponentCommand(config.editingSheet, $component, $order));
			}
		}

		
		
		public static function ordPage($page:Page, $order:int):void
		{
			if ($page)
			{
				var pageArr:Array = $page.parent ? $page.parent.pagesArr : provider.program.children;
				$order = MathUtil.clamp($order, 0, pageArr.length - 1);
				if ($order != $page.order)
					presenter.execute(new OrdPageCommand($page, $order));
			}
		}
		
		/**
		 * 
		 * 修改组件。
		 * 
		 * @param $component:Component 要修改的组件。
		 * @param $scope:Object (default = null) 要修改的组件属性集合，格式为：<br>
		 * {<br>
		 * &nbsp;&nbsp;x:100,<br>
		 * &nbsp;&nbsp;y:100,<br>
		 * &nbsp;&nbsp;width:100,<br>
		 * &nbsp;&nbsp;height:100,<br>
		 * &nbsp;&nbsp;order:2,<br>
		 * &nbsp;&nbsp;label:"组件1"<br>
		 * }
		 * 
		 */
		
		public static function edtComponent($component:Component, $scope:Object = null):void
		{
			if ($component && $scope)
				presenter.execute(new EdtComponentCommand($component, $scope));
		}
		
		
		/**
		 * 
		 * 切换页面层级，将页面移动至某个父级页面的子级，或移动至顶级。
		 * 
		 * @param $page:Page 要改变层级的页面
		 * @param $parent:Page = null (default = null) 父级页面，若为null，则意为改变页面层级至顶级。
		 * 
		 */
		
		public static function altPage($page:Page, $index:uint = uint.MAX_VALUE, $parent:Page = null):void
		{
			if ($page && $page != $parent && PageUtil.isAllowAdd($page, $parent))
			{
				presenter.execute(new AltPageCommand($page, $parent, $index));
				presenter.execute(new OrdPageCommand);
			}
		}
		
		
		/**
		 * 
		 * 添加页面。
		 * 
		 * @param $parent:Page (default = null), 父级页面。
		 * @param $order:uint (default = uint.MAX_VALUE) 顺序。
		 * @param $homeExist:Boolean (default = false) 是否检测首页存在与否，如果检测，则在首页存在的情况下，不创建页面，如果不检测，则创建页面。
		 * 
		 */
		
		public static function addPage($parent:Page = null, $order:uint = uint.MAX_VALUE, $homeExist:Boolean = false):void
		{
			presenter.execute(new AddPageCommand($parent, $order, $homeExist));
//			presenter.execute(new OrdPageCommand);
		}
		
		
		/**
		 * 
		 * 删除页面。
		 * 
		 * @param $page:Page 要删除的页面。
		 * 
		 */
		
		public static function delPage($page:Page):void
		{
			if ($page)
			{
				presenter.execute(new DelPageCommand($page));
//				presenter.execute(new OrdPageCommand());
			}
		}
		
		
		/**
		 * 
		 * 修改版面，版面包含页面和广告。
		 * 
		 * @param $sheet:Sheet 要修改的版面。
		 * @param $scope:Object (default = null) 要修改的版面属性集合，格式为：<br>
		 * {<br>
		 * &nbsp;&nbsp;x:100,<br>
		 * &nbsp;&nbsp;y:100,<br>
		 * &nbsp;&nbsp;width:100,<br>
		 * &nbsp;&nbsp;height:100,<br>
		 * &nbsp;&nbsp;order:2,<br>
		 * &nbsp;&nbsp;label:"组件1"<br>
		 * }
		 * 
		 */
		
		public static function edtSheet($sheet:Sheet, $scope:Object = null):void
		{
			if ($sheet && $scope)
				presenter.execute(new EdtSheetCommand($sheet, $scope))
		}
		
		
		/**
		 * 
		 * 打开版面，版面包含页面和广告。
		 * 
		 * @param $sheet:Sheet 要打开的版面。
		 * 
		 */
		
		public static function openSheet($sheet:Sheet):void
		{
			presenter.execute(new OpenSheetCommand($sheet));
		}
		
		
		/**
		 * 
		 * 全屏。
		 * 
		 */
		
		public static function fullScreen():void
		{
			presenter.execute(new FullScreenCommand);
		}
		
		
		/**
		 * 
		 * 应用数据。
		 * 
		 */
		
		public static function saveData():void
		{
			presenter.execute(new FullScreenCommand(true));
			presenter.execute(new SaveDataCommand);
		}
		
		
		/**
		 * @private
		 */
		private static function getComponentById($id:String):Component
		{
			return config.editingSheet ? config.editingSheet.componentsMap[$id] : null;
		}
		
		/**
		 * @private
		 */
		private static function getSheetById($id:String):Sheet
		{
			return config.editingSheet ? MDProvider.instance.program.sheets[$id] : null;
		}
		
		/**
		 * @private
		 */
		private static var config:MDConfig = MDConfig.instance;
		
		/**
		 * @private
		 */
		private static var provider:MDProvider = MDProvider.instance;
		
		/**
		 * @private
		 */
		private static var presenter:MDPresenter = MDPresenter.instance;
		
		/**
		 * @private
		 */
		private static var vars:MDVars = MDVars.instance;
		
	}
}
package editor.core
{
	
	/**
	 * 
	 * 存储常用变量。
	 * 
	 */
	
	
	import cn.mvc.core.MCObject;
	import cn.mvc.errors.SingleTonError;
	
	import editor.views.Debugger;
	import editor.views.PageContent;
	import editor.views.tabs.TitleTab;
	import editor.vos.Component;
	import editor.vos.Sheet;
	
	import mx.collections.ArrayList;
	
	import spark.components.CheckBox;
	
	
	[Bindable]
	public final class MDConfig extends MCObject
	{
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const instance:MDConfig = new MDConfig;
		
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MDConfig()
		{
			if(!instance)
				super();
			else
				throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 页面可视化
		 * 
		 */
		public function get isLayoutOpened():Boolean
		{
			return MDVars.instance.titleBar.isLayoutOpened;
		}
		
		
		/**
		 * 
		 * 选中的版面视图项。
		 * 
		 */
		
		public function get selectedSheet():Sheet
		{
			return ed::selectedSheet;
		}
		
		/**
		 * @private
		 */
		public function set selectedSheet($value:Sheet):void
		{
			lastSelectedSheet = selectedSheet;
			ed::selectedSheet = $value;
			
			if (lastSelectedSheet) lastSelectedSheet.selected = false;
			if (selectedSheet) selectedSheet.selected = true;
		}
		
		public function get selectedTitle():TitleTab
		{
			return MDVars.instance.titleBar.selected;
		}
		
		/**
		 * 
		 * 节目名称。
		 * 
		 */
		
		public function get selectedComponent():Component
		{
			return ed::selectedComponent;
		}
		
		/**
		 * @private
		 */
		public function set selectedComponent($value:Component):void
		{
			lastSelectedComponent = selectedComponent;
			ed::selectedComponent = $value;
			
			if (lastSelectedComponent) lastSelectedComponent.selected = false;
			if (selectedComponent) selectedComponent.selected = true;
		}
		
		
		/**
		 * 
		 * 正在编辑的版面。
		 * 
		 */
		
		public function get editingSheet():Sheet
		{
			return ed::editingSheet;
		}
		
		/**
		 * @private
		 */
		public function set editingSheet($value:Sheet):void
		{
			lastEditingSheet = editingSheet;
			ed::editingSheet = $value;
			
			if (lastEditingSheet) lastEditingSheet.editing = false;
			if (editingSheet) editingSheet.editing = true;
		}
		
		
		/**
		 * 
		 * 临时记录需要修改的元素（组件，页面）。
		 * 
		 */
		
		public var orders:Array;
		
		
		/**
		 * 
		 * 调试模式。
		 * 
		 */
		public var debug:Boolean;
		
		
		/**
		 * 
		 * 演示模式。
		 * 
		 */
		
		public var demo:Boolean = false;
		

		/**
		 * 
		 * 对齐模式
		 * 
		 */
		
		public var alignMode:Boolean = false;
		
		
		/**
		 * 
		 * 拖拽模式
		 * 
		 */
		
		public var dragOnly:Boolean = false;
		
		
		/**
		 * 
		 * 模版名字 
		 * 
		 */
		
		public var templateName:String;
				
		
		/**
		 * 
		 * 显示网格
		 * 
		 */
		
		public var showGrid:Boolean = true;
		
		
		/**
		 * 
		 * 模版数据临时存储器。
		 * 
		 */
		
		public var templateData:Array = [];
		
		
		/**
		 * @private
		 */
		private var lastSelectedSheet:Sheet;
		
		/**
		 * @private
		 */
		private var lastEditingSheet:Sheet;
		
		/**
		 * @private
		 */
		private var lastSelectedComponent:Component;
		
		
		public var mode:String;
		
		
		public var isRead:Boolean;
		
		
		/**
		 * @private
		 */
		ed var checkBox:CheckBox;
		
		/**
		 * @private
		 */
		ed var selectedSheet:Sheet;
		
		/**
		 * @private
		 */
		ed var editingSheet:Sheet;
		
		/**
		 * @private
		 */
		ed var selectedComponent:Component;
		
	}
}
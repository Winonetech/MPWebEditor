package editor.core
{
	
	/**
	 * 
	 * 存储常用视图。
	 * 
	 */
	
	
	import cn.mvc.core.MCObject;
	import cn.mvc.errors.SingleTonError;
	
	import editor.views.ComponentList;
	import editor.views.ComponentsAddone;
	import editor.views.EditorView;
	import editor.views.PageSelector;
	import editor.views.ProgressWindow;
	import editor.views.SheetCanvas;
	import editor.views.SheetTree;
	import editor.views.tabs.TitleBar;
	
	import spark.components.Application;
	
	import w11k.flash.AngularJSAdapter;
	
	
	public final class MDVars extends MCObject
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MDVars()
		{
			if(!instance)
				super();
			else
				throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const instance:MDVars = new MDVars;
		
		
		/**
		 * 
		 * 主入口。
		 * 
		 */
		
		public var application:Application;
		
		
		/**
		 * 
		 * 编辑视图。
		 * 
		 */
		
		public var editorView:EditorView;
		
		
		/**
		 * 
		 * 选择页面视图。
		 * 
		 */
		
		public var selector:PageSelector;
		
		
		/**
		 * 
		 * 版面树。
		 * 
		 */
		
		public var sheets:SheetTree;
		
		
		/**
		 * 
		 * 元素类型面板。
		 * 
		 */
		
		public var addone:ComponentsAddone;
		
		
		/**
		 * 
		 * 元素类型面板。
		 * 
		 */
		
		public var canvas:SheetCanvas;
		
		
		/**
		 * 
		 * 组件列表。
		 * 
		 */
		
		public var components:ComponentList;
		
		
		/**
		 * 
		 * 保存进度窗口。
		 * 
		 */
		
		public var progress:ProgressWindow;
		
		
		/**
		 * 
		 * 外部容器交互处理器。
		 * 
		 */
		
		public var adapter:AngularJSAdapter;
		
		public var titleBar:TitleBar;
		
	}
}
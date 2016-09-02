package editor.core
{
	
	/**
	 * 
	 * 数据源。
	 * 
	 */
	
	
	import cn.mvc.core.MCObject;
	import cn.mvc.errors.SingleTonError;
	
	import editor.vos.PLayout;
	
	
	[Bindable]
	public class MDProvider extends MCObject
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MDProvider()
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
		
		public static const instance:MDProvider = new MDProvider;
		
		
		/**
		 * 
		 * 域。
		 * 
		 */
		
		public var domain:String;
		
		
		/**
		 * 
		 * 节目ID。
		 * 
		 */
		
		public var programID:String;
		
		
		/**
		 * 
		 * 布局ID。
		 * 
		 */
		
		public var layoutID:String;
		
		
		/**
		 * 
		 * 节目名称。
		 * 
		 */
		
		public var programName:String;
		
		
		/**
		 * 
		 * 默认宽度。
		 * 
		 */
		
		public var defaultWidth:Number = 0;
		
		
		/**
		 * 
		 * 默认高度。
		 * 
		 */
		
		public var defaultHeight:Number = 0;
		
		
		/**
		 * 
		 * 版面集。
		 * 
		 */
		
		public var program:PLayout;
		
		
		/**
		 * 
		 * 元素集合。
		 * 
		 */
		
		public var raw:Object ={};
		
	}
}
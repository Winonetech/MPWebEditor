package cn.mvc.controls
{
	
	/**
	 * 
	 * 
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.UI;
	import cn.mvc.core.vs;
	
	
	public class Image extends UI
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function Image()
		{
			super();
		}
		
		
		/**
		 * 
		 * 设定资源。
		 * 
		 */
		
		public function get source():Object
		{
			return vs::source;
		}
		
		/**
		 * @private
		 */
		public function set source($value:Object):void
		{
			if ($value!= source)
			{
				vs::source = $value;
			}
		}
		
		
		/**
		 * @private
		 */
		vs var source:Object;
		
	}
}
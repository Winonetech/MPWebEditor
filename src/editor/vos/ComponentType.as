package editor.vos
{
	
	/**
	 * 
	 * 组件类型数据结构。
	 * 
	 */
	
	
	[Bindable]
	public final class ComponentType extends _InternalVO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function ComponentType($data:Object = null, $name:String = "componentType")
		{
			super($data, $name);
		}
		
		
		/**
		 * 
		 * 标签。
		 * 
		 */
		
		public function get label():String
		{
			return getProperty("label");
		}
		
		
		/**
		 * 
		 * 图标。
		 * 
		 */
		
		public function get icon():String
		{
			return getProperty("icon");
		}
		
		
		/**
		 * 
		 * 图片。
		 * 
		 */
		
		public function get image():String
		{
			return getProperty("image");
		}
		
		
		/**
		 * 
		 * 编码。
		 * 
		 */
		
		public function get code():String
		{
			return getProperty("code");
		}
		
		
		/**
		 * 
		 * 顺序。
		 * 
		 */
		
		public function get order():uint
		{
			return getProperty("order", uint);
		}
		
		
		/**
		 * 
		 * 获取属性集合。
		 * 
		 */
		
		public function get property():Object
		{
			return getProperty("property", Object);
		}
		
	}
}
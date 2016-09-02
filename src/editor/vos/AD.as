package editor.vos
{
	
	/**
	 * 
	 * 广告版面数据结构。
	 * 
	 */
	
	
	public final class AD extends Sheet
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function AD($data:Object = null, $name:String = "ad")
		{
			super($data, $name);
		}
		
		
		/**
		 * 
		 * 无人值守时长。
		 * 
		 */
		[Bindable]
		public function get waitTime():uint
		{
			return getProperty("waitTime", uint);
		}
		
		/**
		 * @private
		 */
		public function set waitTime($value:uint):void
		{
			setProperty("waitTime", $value);
		}
		
		
		/**
		 * 
		 * 是否启用广告。
		 * 
		 */
		[Bindable]
		public function get enabled():Boolean
		{
			return getProperty("adEnabled", Boolean);
		}
		
		/**
		 * @private
		 */
		public function set enabled($value:Boolean):void
		{
			setProperty("adEnabled", $value);
		}
		
	}
}
package cn.mvc.utils
{
	
	/**
	 * 
	 * <code>JSONUtil</code>定义了一些JSON操作函数。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.NoInstance;
	
	
	public final class JSONUtil extends NoInstance
	{
		
		/**
		 * 
		 * 验证是否为JSON格式字符串。
		 * 
		 * @param $value:* 验证的字符串。
		 * 
		 * @return Boolean 是否为JSON格式字符串。
		 * 
		 */
		
		public static function validate($value:String):Boolean
		{
			var c:String = $value.charAt(0);
			return c == "{" || c == "[";
		}
	}
}
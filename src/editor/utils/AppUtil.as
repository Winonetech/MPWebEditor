package editor.utils
{
	import cn.mvc.core.NoInstance;
	
	import editor.core.MDConfig;
	
	
	public final class AppUtil extends NoInstance
	{
		
		/**
		 * 
		 * 判断是否为填充模式
		 * 
		 */
		
		public static function isFillMode():Boolean
		{
			return MDConfig.instance.mode == "fill";
		}
		
		
		/**
		 * 
		 * 判断是否为编辑模式
		 * 
		 */
		
		public static function isEditMode():Boolean
		{
			return MDConfig.instance.mode == "edit";
		}
		
		
		/**
		 * 
		 * 判断是否为编辑模版模式 
		 * 
		 */
		public static function isTemplate():Boolean
		{
			return MDConfig.instance.mode == "template";
		}
		
	}
}
package cn.mvc.managers
{
	
	/**
	 * 
	 * 命令类管理器。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.collections.Map;
	import cn.mvc.core.Command;
	import cn.mvc.utils.ClassUtil;

	
	public final class CommandManager extends Manager
	{
		
		/**
		 * 
		 * 注册一种命令类。
		 * 
		 */
		
		public static function registCommand($name:String, $command:Class):Boolean
		{
			return (commands[$name] || (! ClassUtil.validateSubclass($command, Command)))
				? false 
				: commands[$name] = $command;
		}
		
		
		/**
		 * 
		 * 删除一种命令类。
		 * 
		 */
		
		public static function removeCommand($name:String):Boolean
		{
			var result:Boolean = commands[$name];
			if (result) delete commands[$name];
			return result;
		}
		
		
		/**
		 * 
		 * 获取一种命令类。
		 * 
		 */
		
		public static function retrieveCommand($name:String):Class
		{
			return commands[$name];
		}
		
		
		/**
		 * @private
		 */
		private static const commands:Map = new Map;
		
	}
}
package cn.mvc.commands
{
	
	/**
	 * 
	 * 撤销机制命令，与队列结合起来使用。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.Command;
	import cn.mvc.core.vs;
	
	public class RevocableCommand extends Command
	{
		public function RevocableCommand($revocable:Boolean = true)
		{
			super();
		}
		
		
		/**
		 * 
		 * 能否被撤销。
		 * 
		 */
		
		public function get revmcable():Boolean
		{
			return vs::revocable as Boolean;
		}
		
		
		/**
		 * @private
		 */
		vs var revocable:Boolean;
		
	}
}
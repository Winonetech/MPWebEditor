package cn.mvc.events
{
	
	/**
	 * 
	 * 可撤销命令事件。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.commands.RevocableCommand;
	import cn.mvc.core.Command;
	
	
	public class RevocableCommandEvent extends CommandEvent
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function RevocableCommandEvent($type:String, $command:RevocableCommand, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $command, $bubbles, $cancelable);
		}
		
		
		/**
		 * 
		 * 撤销开始。
		 * 
		 * @default undoStart
		 * 
		 */
		
		public static const UNDO_START:String = "undoStart";
		
		
		/**
		 * 
		 * 撤销结束。
		 * 
		 * @default undoEnd
		 * 
		 */
		
		public static const UNDO_END:String = "undoEnd";
		
		
		/**
		 * 
		 * 重做开始。
		 * 
		 * @default redoStart
		 * 
		 */
		
		public static const REDO_START:String = "redoStart";
		
		
		/**
		 * 
		 * 重做结束。
		 * 
		 * @default redoEnd
		 * 
		 */
		
		public static const REDO_END:String = "redoEnd";
		
	}
}
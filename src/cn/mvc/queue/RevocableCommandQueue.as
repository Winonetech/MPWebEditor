package cn.mvc.queue
{
	
	/**
	 * 
	 * 撤销机制命令队列。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.vs;
	import cn.mvc.core.Command;
	
	
	public final class RevocableCommandQueue extends SequenceQueue
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function RevocableCommandQueue()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			commandsUndo = new Vector.<Command>;
			commandsRedo = new Vector.<Command>;
		}
		
		
		override public function execute($command:Command = null):void
		{
			super.execute($command);
			
			
		}
		
		
		/**
		 * 
		 * 撤销上一个命令。
		 * 
		 */
		
		public function undo():void
		{
			
		}
		
		
		/**
		 * 
		 * 重做上一个撤销的命令。
		 * 
		 */
		
		public function redo():void
		{
			
		}
		
		
		/**
		 * 可撤销命令队列。
		 */
		private var commandsUndo:Vector.<Command>;
		
		/**
		 * 可重做命令队列。
		 */
		private var commandsRedo:Vector.<Command>;
		
	}
}
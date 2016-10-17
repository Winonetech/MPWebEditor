package cn.mvc.commands
{
	
	/**
	 * 
	 * 撤销机制命令，与可撤销队列结合起来使用。
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
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function RevocableCommand($revocable:Boolean = true)
		{
			super();
			
			revocable = $revocable;
		}
		
		
		/**
		 * 
		 * 命令重做。<br>
		 * 开发人员在重写子类时，如果是异步命令，需覆盖此方法，并在重做的开始与结束时调用
		 * commandStart和commandEnd方法；如果是同步命令，则无需重写此方法，只需重写
		 * processRedo。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.processRedo()
		 * 
		 */
		
		public function redo():void
		{
			if (revocable)
			{
				commandStart();
				
				processRedo();
				
				commandEnd();
			}
		}
		
		
		/**
		 * 
		 * 命令撤销。<br>
		 * 开发人员在重写子类时，如果是异步命令，需覆盖此方法，并在撤销的开始与结束时调用
		 * commandStart和commandEnd方法；如果是同步命令，则无需重写此方法，只需重写
		 * processUndo。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.processUndo()
		 * 
		 */
		
		public function undo():void
		{
			if (revocable)
			{
				commandStart();
				
				processUndo();
				
				commandEnd();
			}
		}
		
		
		/**
		 * 
		 * 命令重做。<br>
		 * 重写命令的子类且是同步命令时，需要覆盖此方法。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.redo()
		 * 
		 */
		
		protected function processRedo():void { }
		
		
		/**
		 * 
		 * 命令撤销。<br>
		 * 重写命令的子类且是同步命令时，需要覆盖此方法。
		 * 
		 * @see cn.mvc.commands.RevocableCommand.undo()
		 * 
		 */
		
		protected function processUndo():void { }
		
		
		/**
		 * 
		 * 是否允许撤销与反撤销。<br>
		 * 
		 * @default true
		 * 
		 */
		
		public var revocable:Boolean = true;
		
	}
}
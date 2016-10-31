package editor.core
{
	
	/**
	 * 
	 * 总程序处理。
	 * 
	 */
	
	
	import cn.mvc.core.Command;
	import cn.mvc.core.Presenter;
	import cn.mvc.errors.SingleTonError;
	import cn.mvc.queue.RevocableCommandQueue;
	import cn.mvc.queue.SequenceQueue;
	
	import editor.commands.InitEnvironmentCommand;
	import editor.consts.DataConsts;
	import editor.utils.CommandUtil;
	
	
	public final class MDPresenter extends Presenter
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function MDPresenter()
		{
			if(!instance)
				super();
			else
				throw new SingleTonError(this);
		}
		
		
		/**
		 * 
		 * 单例引用。
		 * 
		 */
		
		public static const instance:MDPresenter = new MDPresenter;
		
		
		/**
		 * 
		 * 执行命令。
		 * 
		 */
		
		public function execute($command:Command):void
		{
			queue.execute($command);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function setup(...parameters):void
		{
			vars.application = app;
			
			config.debug = parameters[0];
			
			setupCommands();
		}
		
		
		/**
		 * @private
		 */
		private function setupCommands():void
		{
			execute(new InitEnvironmentCommand);
			
			if (config.debug)
				CommandUtil.transmitData(JSON.stringify(DataConsts.PROGRAM, null, "\t"));
		}
		
		
		/**
		 * 
		 * 队列是否正在执行。
		 * 
		 */
		
		public function get executing():Boolean
		{
			return queue.executing;
		}
		
		
		public function redo():void
		{
			queue.redo();
		}
		
		
		public function undo():void
		{
			queue.undo();
		}
		
		
		/**
		 * @private
		 */
		private var queue:RevocableCommandQueue = new RevocableCommandQueue;
		
		/**
		 * @private
		 */
		private var config:MDConfig = MDConfig.instance;
		
		/**
		 * @private
		 */
		private var vars:MDVars = MDVars.instance;
		
	}
}
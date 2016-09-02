package editor.commands
{
	
	/**
	 * 
	 * 命令基类。
	 * 
	 */
	
	
	import cn.mvc.core.Command;
	
	import editor.core.MDConfig;
	import editor.core.MDPresenter;
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.Debugger;
	
	
	internal class _InternalCommand extends Command
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			try
			{
				excuteCommand();
			}
			catch (e:Error) 
			{
				log(e.getStackTrace());
			}
			
			commandEnd();
		}
		
		
		/**
		 * 
		 * 执行命令，子类覆盖该方法以便具体执行某项任务。
		 * 
		 */
		
		protected function excuteCommand():void
		{
			
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function commandStart():void
		{
			log(className + ".commandStart()");
			super.commandStart();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function commandEnd():void
		{
			log(className + ".commandEnd()");
			super.commandEnd();
		}
		
		
		/**
		 * 
		 * 打印输出。
		 * 
		 */
		
		protected function log(...$args):void
		{
			Debugger.log.apply(null, $args);
		}
		
		
		/**
		 * 
		 * 变量配置引用。
		 * 
		 */
		
		protected function get config():MDConfig
		{
			return MDConfig.instance;
		}
		
		
		/**
		 * 
		 * 处理器引用。
		 * 
		 */
		
		protected function get presenter():MDPresenter
		{
			return MDPresenter.instance;
		}
		
		
		/**
		 * 
		 * 数据源引用。
		 * 
		 */
		
		protected function get provider():MDProvider
		{
			return MDProvider.instance;
		}
		
		
		/**
		 * 
		 * 数据源引用。
		 * 
		 */
		
		protected function get vars():MDVars
		{
			return MDVars.instance;
		}
		
	}
}
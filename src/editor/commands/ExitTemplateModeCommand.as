package editor.commands
{

	/**
	 * 
	 * 退出模版模式。
	 * 
	 */
	
	import w11k.flash.AngularJSAdapter;
	
	public class ExitTemplateModeCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function ExitTemplateModeCommand()
		{
			super();
		}
		
		
		override protected function excuteCommand():void
		{
			AngularJSAdapter.getInstance().call("confirm()");
		}
		
		
	}
}
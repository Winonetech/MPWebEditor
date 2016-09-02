package editor.commands
{
	
	/**
	 * 
	 * 显示排版。
	 * 
	 */
	
	
	public final class ShowSheetsCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function ShowSheetsCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			vars.sheets.program = provider.program;
		}
		
	}
}
package editor.commands
{
	
	/**
	 * 
	 * 填充背景命令。
	 * 
	 */
	
	public final class FillSheetBackgroundCommand extends _InternalCommand
	{
		public function FillSheetBackgroundCommand($sheetId:String, $background:String)
		{	
			super();
			sheet["sheetId"] = $sheetId;
			sheet["background"] = $background;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			vars.adapter.call("setSheetBackground(sheet)", {"sheet" : sheet});
		}
		
		
		/**
		 * @private
		 */
		private var sheet:Object = {};
		
	}
}
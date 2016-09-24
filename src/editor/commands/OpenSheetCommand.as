package editor.commands
{
	
	/**
	 * 
	 * 编辑版面。
	 * 
	 */
	
	
	import editor.vos.Sheet;
	
	import flash.events.MouseEvent;
	
	
	public final class OpenSheetCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $sheet:Sheet (default = null) 要打开的版面，为空时默认打开首页。
		 * 
		 */
		
		public function OpenSheetCommand($sheet:Sheet = null)
		{
			super();
			
			sheet = $sheet;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (vars.canvas && provider.program)
			{
				if(!sheet) sheet = provider.program.home;
				
				vars.titleBar.isLayoutOpened = false;
				config.editingSheet = sheet;
				
				config.selectedComponent = null;
				
				vars.titleBar.addTitle(sheet);
				
//				if (config.isLayoutOpened) vars.canvas.update();   //解决当 "布局"被选定同时以双击 SheetTree的方式打开其他标题时，画布不更新的BUG。
			}
		}
		
		
		/**
		 * @private
		 */
		private var sheet:Sheet;
		
	}
}
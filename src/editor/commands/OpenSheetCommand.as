package editor.commands
{
	
	/**
	 * 
	 * 编辑版面。
	 * 
	 */
	
	
	import editor.utils.TabUtil;
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
				TabUtil.addTitle(sheet);
			}
		}
		
		
		/**
		 * @private
		 */
		private var sheet:Sheet;
		
	}
}
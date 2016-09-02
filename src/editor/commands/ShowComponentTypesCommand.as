package editor.commands
{
	
	/**
	 * 
	 * 显示元素类型。
	 * 
	 */
	
	
	public final class ShowComponentTypesCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function ShowComponentTypesCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (vars.addone && provider.program)
				vars.addone.dataProvider = provider.program.componentTypesArr;
		}
		
	}
}
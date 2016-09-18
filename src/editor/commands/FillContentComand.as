package editor.commands
{
	
	/**
	 * 
	 * 填充内容命令。
	 * 
	 */
	
	
	public final class FillContentComand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function FillContentComand($componentId:String, $componentCode:String)
		{
			super();
			
			component["componentCode"] = $componentCode;
			component["componentId"] = $componentId;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override public function execute():void
		{
			commandStart();
			
			excuteCommand();
			
			commandEnd();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			vars.adapter.call("fillComponent(component)", {"component" : component});
		}
		
		
		/**
		 * @private
		 */
		private var component:Object = {};
		
	}
}
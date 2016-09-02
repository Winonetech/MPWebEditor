package editor.commands
{
	
	/**
	 * 
	 * 保存数据。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	
	import w11k.flash.AngularJSAdapter;
	
	
	public final class SaveDataCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function SaveDataCommand()
		{
			super();
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(URLConsts.URL_LAYOUT_APPLY, provider);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			communicate();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			AngularJSAdapter.getInstance().call("confirm()");
		}
		
	}
}
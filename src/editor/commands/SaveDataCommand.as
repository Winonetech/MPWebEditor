package editor.commands
{
	
	/**
	 * 
	 * 保存数据。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
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
			if(isComponentEmpty())
			{
				Alert.show("当前节目无任何组件！", "警告", Alert.OK, null,
					function($e:CloseEvent):void{commandEnd();});
			}
			else 
			{
				communicate();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			AngularJSAdapter.getInstance().call("confirm()");
		}
		
		private function isComponentEmpty():Boolean
		{
			return provider.program.components.length == 0;
		}
		
	}
}
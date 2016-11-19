package editor.commands
{
	
	/**
	 * 
	 * 加载模版数据
	 * 
	 */
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Page;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class GainTamplateDataCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function GainTamplateDataCommand()
		{
			super();
			
			revocable = false;
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(URLConsts.URL_LAYOUT_GAINTEMPLATE, provider);
		}
		
		
		override protected function excuteCommand():void
		{
			communicate();
		}
		
		override protected function update($result:Object=null):void
		{
			if ($result is String) $result = JSON.parse($result as String);
			if ($result.result == "success")
			{
				for each (var page:Object in $result.dataObjs)
				{
					vars.tempSelector.myList.dataProvider.addItem(page);
//					ArrayUtil.push(config.templateData, page);
					config.templateData.push(page);
				}
			}
			else
			{
				Debugger.log("加载模版数据出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
	}
}
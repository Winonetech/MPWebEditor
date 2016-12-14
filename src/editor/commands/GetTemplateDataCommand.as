package editor.commands
{
	
	/**
	 * 
	 * 获取模版数据。
	 * 
	 */
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.core.MDVars;
	import editor.views.Debugger;
	
	
	public class GetTemplateDataCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function GetTemplateDataCommand()
		{
			super();
			
			revocable = false;
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(URLConsts.URL_LAYOUT_GETTEMPLATE, provider);
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
					vars.tempSelector.temp.addItem(page);
					config.templateData.push(page);
				}
			}
			else
			{
				Debugger.log("获取模版数据出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
		
			
	}
}
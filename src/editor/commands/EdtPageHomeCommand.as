package editor.commands
{
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Page;

	public final class EdtPageHomeCommand extends _InternalCommCommand
	{
		public function EdtPageHomeCommand($changed:Page, $changing:Page, $revocable:Boolean = true)
		{
			super();
			
			revocable = $revocable
			changed  = $changed;
			changing = $changing; 
			
			url = RegexpUtil.replaceTag(URLConsts.URL_PAGE_AMD, provider);
		}
		
		
		override protected function excuteCommand():void
		{
			updatable = false;
			
			if (changed != changing) updatable = true;
			
			if (updatable)
			{
				if (changed)
				{
					changed.home = false;
					
					var data:Object = JSON.parse(changed.toJSON());    //parse = String -> Object
					
					delete data.pages;
					delete data.components;
					
					communicate(JSON.stringify(data), false);
				}
				
				if (changing)
				{
					changing.home = true;
					
					var data1:Object = JSON.parse(changing.toJSON());    //parse = String -> Object
					
					delete data1.pages;
					delete data1.components;
					
					communicate(JSON.stringify(data1));
				}
				else commandEnd();
			}
			else commandEnd();
		}
		
		
		override protected function update($result:Object=null):void
		{
			if ($result is String) $result = JSON.parse($result as String);
			if ($result.result == "success")
			{
				//update view
				if (updatable) 
				{
					vars.canvas.update();
				}
			}
			else
			{
				Debugger.log("修改主页出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
		
		private var updatable:Boolean;	
			
		private var changed:Page;
		
		private var changing:Page;
	}
}
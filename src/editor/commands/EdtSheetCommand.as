package editor.commands
{
	
	/**
	 * 
	 * 编辑版面，版面可以是页面和广告。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	import cn.mvc.utils.StringUtil;
	
	import editor.consts.URLConsts;
	import editor.utils.ComponentUtil;
	import editor.utils.TabUtil;
	import editor.views.Debugger;
	import editor.views.tabs.TitleTab;
	import editor.vos.AD;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	
	public final class EdtSheetCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $sheet:Sheet 要修改的版面。
		 * @param $scope:Object 要修改的版面属性集合，格式为：<br>
		 * {<br>
		 * &nbsp;&nbsp;x:100,<br>
		 * &nbsp;&nbsp;y:100,<br>
		 * &nbsp;&nbsp;width:100,<br>
		 * &nbsp;&nbsp;height:100,<br>
		 * &nbsp;&nbsp;order:2,<br>
		 * &nbsp;&nbsp;label:"组件1"<br>
		 * }
		 * 
		 */
		
		public function EdtSheetCommand($sheet:Sheet, $scope:Object, $revovabel:Boolean = true)
		{
			super();
			
			item  = $sheet;
			scope = $scope;
			
			revocable = $revovabel;
			
			url = RegexpUtil.replaceTag((item is Page) 
				? URLConsts.URL_PAGE_AMD 
				: URLConsts.URL_AD_MOD, provider);
		}
		
		override protected function processUndo():void
		{
			for (var key:String in last)
			{
				if ((key == "width" || key == "height") && last[key] != pres[key]) ComponentUtil.limitSheetComponents(
					 last[key] / pres[key], key, item);
				item[key] = last[key];
			}
			
			
			var data:Object = JSON.parse(item.toJSON());
			
			delete data.pages;
			delete data.components;
			
			if (StringUtil.empty(data.label))
				data.label = (item is AD) ? "广告" : "页面";
			
			communicate(JSON.stringify(data));
		}
		
		
		
		override protected function processRedo():void
		{
			for (var key:String in pres)
			{
				if ((key == "width" || key == "height") && last[key] != pres[key]) ComponentUtil.limitSheetComponents(
					pres[key] / last[key], key, item);
				item[key] = pres[key];
			}
			
			var data:Object = JSON.parse(item.toJSON());    //parse = String -> Object
			
			delete data.pages;
			delete data.components;
			
			if (StringUtil.empty(data.label))
				data.label = (item is AD) ? "广告" : "页面";
			
			communicate(JSON.stringify(data));
			
		}
		
		
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			//update data
			updatable = false;
			for (var key:String in scope)
			{
				try {
					if (!updatable && String(item[key]) != String(scope[key])) 
					{
						updatable = true;
					}
					last[key] = item[key];
					pres[key] = scope[key];
					item[key] = scope[key];
				} catch(e:Error) {trace(e.getStackTrace())}
			}
			
			
			if (updatable)
			{
				var data:Object = JSON.parse(item.toJSON());
				
				delete data.pages;
				delete data.components;
				
				if (StringUtil.empty(data.label))
					data.label = (item is AD) ? "广告" : "页面";
				
				communicate(JSON.stringify(data));
			}
			else
			{
				commandEnd();
			}
			
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			if ($result is String) $result = JSON.parse($result as String);
			if ($result.result == "success")
			{
				//update view
				if (updatable) 
				{
//					if (config.isLayoutOpened)
//					{
//						vars.canvas.content.updatePage(item as Page);
//					}
//					else 
//					{
					vars.canvas.update();
//					}
					config.selectedComponent = null;
				}
			}
			else
			{
				Debugger.log("修改" + item.label + "数据出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
		
		private var lastItem:TitleTab;
		
		/**
		 * @private
		 */
		private var item:Sheet;
		
		/**
		 * @private
		 */
		private var scope:Object;
		
		/**
		 * @private
		 */
		private var updatable:Boolean;
		
		private var last:Object = {};
		
		private var pres:Object = {};
		
	}
}
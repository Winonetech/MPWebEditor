package editor.commands
{
	
	/**
	 * 
	 * 更改页面父级。
	 * 
	 */
	
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Page;
	
	
	public final class AltPageCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function AltPageCommand($page:Page, $parent:Page = null, $index:uint = uint.MAX_VALUE)
		{
			super();
			
			page     = $page;
			parent   = $parent;
			index    = $index;
			
			url = RegexpUtil.replaceTag(URLConsts.URL_PAGE_AMD, provider);
		}
		
		
		override protected function processUndo():void
		{
			config.orders = provider.program.altPage(page, last["parent"], last["order"]);
			url = RegexpUtil.replaceTag(URLConsts.URL_PAGE_AMD, provider);
			if (last["parent"])
			{
				page.parentID = last["parent"].id;
				page.layoutID = null;
			}
			else
			{
				page.layoutID = provider.layoutID;
				page.parentID = null;
			}
			
			var data:Object = JSON.parse(page.toJSON());
			
			delete data.pages;
			delete data.components;
			
			communicate(JSON.stringify(data), false);
		}
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			last["order"] = page.order;
			last["parent"] = page.parent;
			
			config.orders = provider.program.altPage(page, parent, index);
			if (parent)
			{
				page.parentID = parent.id;
				page.layoutID = null;
			}
			else
			{
				page.layoutID = provider.layoutID;
				page.parentID = null;
			}
				
			var data:Object = JSON.parse(page.toJSON());
			
			delete data.pages;
			delete data.components;
			
			communicate(JSON.stringify(data), false);
		}
		
		
		private function altPage():void
		{
			url = RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_ORD), provider);
			
			method = "POST";
			
			var orders:Array = config.orders;
			
			config.orders = null;
			
			var submits:Array, child:Page;
			for each (child in orders)
			{
				submits = submits || [];
				ArrayUtil.push(submits, {
					"id"    : child.id,
					"order" : child.order
				});
			}
			submits
			? communicate(JSON.stringify(submits))
				: commandEnd(); 
		}
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			if(url == RegexpUtil.replaceTag(URLConsts.URL_PAGE_AMD, provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					altPage();
					//update view
					vars.sheets.update();
				}
				else
				{
					Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
				}
			}
			else if(url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_ORD), provider))
			{
				if ($result == "ok")
				{
//					if (vars.sheets)
						vars.sheets.update();
				}
				else
				{
					Debugger.log("修改顺序出错");
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function isSub($page:Page, $parent:Page):Boolean
		{
			var temp:Page = $page && $page.parent;
			while (temp && temp != $parent) temp = temp.parent;
			return (temp && temp == $parent);
		}
		
		
		/**
		 * @private
		 */
		private var parent:Page;
		
		/**
		 * @private
		 */
		private var page:Page;
		
		/**
		 * @private
		 */
		private var data:Object;
		
		/**
		 * @private
		 */
		private var index:uint;
		
		private var last:Object = {};
		
	}
}
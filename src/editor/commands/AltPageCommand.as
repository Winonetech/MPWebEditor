package editor.commands
{
	
	/**
	 * 
	 * 更改页面父级。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Page;
	
	import mx.controls.Alert;
	
	
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
			
			page   = $page;
			parent = $parent;
			index  = $index;
			
			url = RegexpUtil.replaceTag(URLConsts.URL_PAGE_AMD, provider);
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
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
				
				communicate(JSON.stringify(data));
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
				vars.sheets.update();
			}
			else
			{
				Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
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
	}
}
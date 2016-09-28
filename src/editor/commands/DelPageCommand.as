package editor.commands
{
	
	/**
	 * 
	 * 删除页面。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.utils.TabUtil;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Page;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	
	public final class DelPageCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $page:Page 要删除的页面。
		 * 
		 */
		
		public function DelPageCommand($page:Page)
		{
			super();
			
			page = $page;
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_DEL, page), provider);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (page)
			{
				Alert.show("确定删除 " + page.label + " 吗？", "提示",
					Alert.OK|Alert.CANCEL, null,
					function(e:CloseEvent):void {
						e.detail == Alert.OK ? communicate() : commandEnd();
				});
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
				//update data
				config.orders = provider.program.delPage(page);
				clearComponentsLinkID(page.id);
				
				//update view
				vars.sheets.update();
				
				if (vars.titleBar && config.isLayoutOpened)
					vars.canvas.content.updatePage(page, 2);
				//clear select, editing
				if (page == config.selectedSheet) config.selectedSheet = null;
				if (page == config.editingSheet ) config.editingSheet  = null;
				
				if (TabUtil.sheet2Tab(page))
					TabUtil.sheet2Tab(page).closePage();
			}
			else
			{
				Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
		
		/**
		 * @private
		 */
		private function clearComponentsLinkID($id:String):void
		{
			if (provider.program)
			{
				for each (var component:Component in provider.program.components)
					if (component.linkID == $id) component.link = null;
			}
		}
		
		
		/**
		 * @private
		 */
		private var page:Page;
		
	}
}
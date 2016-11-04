package editor.commands
{
	
	/**
	 * 
	 * 删除页面。
	 * 
	 */
	
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.utils.TabUtil;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Page;
	
	import flash.utils.getQualifiedClassName;
	
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
		
		public function DelPageCommand($page:Page, $revocable:Boolean = true)
		{
			super();
			
			page = $page;
			revocable = $revocable;
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_DEL, page), provider);
		}
		
		
		
		override protected function processRedo():void
		{
			presenter.execute(new DelPageCommand(page, false));
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (page)
			{
				if (revocable)
					Alert.show("确定删除 " + page.label + " 吗？", "提示",
						Alert.OK|Alert.CANCEL, null,
						function(e:CloseEvent):void {
							e.detail == Alert.OK ? communicate(null, false) : commandEnd();
					});
				else communicate(null, false);
			}
			else
			{
				commandEnd();
			}
		}
		
		
		private function delPage():void
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
			if(url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_DEL, page), provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					//update data
					config.orders = provider.program.delPage(page);
					clearComponentsLinkID(page.id);
					
					delPage();
					//update view
					vars.sheets.update();
					vars.canvas.content.update();
					//clear select, editing
					if (page == config.selectedSheet) config.selectedSheet = null;
					if (page == config.editingSheet ) config.editingSheet  = null;
					
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
					if (vars.sheets)
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
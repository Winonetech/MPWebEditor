package editor.commands
{
	
	/**
	 * 
	 * 删除页面。
	 * 
	 */
	
	
	import cn.mvc.collections.Map;
	import cn.mvc.core.Command;
	import cn.mvc.events.CommandEvent;
	import cn.mvc.events.RevocableCommandEvent;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.core.MDVars;
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
		
		
		override protected function processUndo():void
		{
			url = RegexpUtil.replaceTag(URLConsts.URL_PAGE_DEL_UNDO, provider);
			method = "POST";

			communicate(JSON.stringify(arr4Comm), false);
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
			page ? communicate(null, false) : commandEnd();
		}
		
		
		private function addPage():void
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
			if (url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_DEL, page), provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					getChildArr(page);
					ArrayUtil.push(arr4Comm, {"pageIds" : arrPageId, "componentIds" : arrComponentId});
					lastHome = isHome();

					
					//update data
					config.orders = provider.program.delPage(page);
					clearComponentsLinkID(page.id);
					
					addPage();
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
			else if (url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_ORD), provider))
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
			else if (url == RegexpUtil.replaceTag(URLConsts.URL_PAGE_DEL_UNDO, provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == 2)
				{
					
					returnPage(page);
//					provider.program.home = provider.program.home || lastHome;
					
					//执行撤销后设置首页
					if(provider.program)
					{
						if(lastHome)
						presenter.execute(new EdtPageHomeCommand(provider.program.home, page, false));
					}
					
					vars.sheets.update();
					vars.canvas.content.update();
					//clear select, editing
					config.selectedSheet = page;
					
				}
				else 
				{
					Debugger.log("撤销删除页面出错");
				}
				
			}
		}
		
		
		private function isHome():Boolean
		{
			return page == provider.program.home;
		}
		
		private function returnPage($page:Page):void
		{
			$page.order = map4Backups[$page.id]["order"];
			
			config.orders = provider.program.addPage($page, $page.parent, true);
			
			addPage();
			
			recoverComponentsLinkID($page);
			for (var i:int = 0; i < map4Backups[$page.id]["arr"].length; i++)
			{
				returnPage(map4Backups[$page.id]["arr"][i]); 
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
		
		
		private function recoverComponentsLinkID($page:Page):void
		{
			for each (var component:Component in $page.componentsMap)
			{
				component.link   = $page;
			}
		}
		
		
		/**
		 *
		 * 进行备份操作。
		 * 
		 */
		
		private function getChildArr($page:Page):void
		{
			arrPageId.push($page.id);
			for (var temp:String in $page.componentsMap) arrComponentId.push(temp);
			
			map4Backups[$page.id] = {"arr" : $page.pagesArr.concat(), "order" : $page.order};
			for (var i:uint = 0; i < $page.pagesArr.length; i++)
			{
				getChildArr($page.pagesArr[i]); 
			}
		}
		
		/**
		 * @private
		 */
		private var page:Page;
		
		private var map4Backups:Map = new Map;
		
		private var arr4Comm:Array = [];
		
		private var arrPageId:Array = [];
		
		private var arrComponentId:Array = [];
		
		private var lastHome:Boolean;
		
	}
}
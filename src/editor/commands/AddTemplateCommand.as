package editor.commands
{
	
	/**
	 * 
	 * 添加模版。
	 * 
	 */
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.core.MDConfig;
	import editor.core.MDVars;
	import editor.utils.CommandUtil;
	import editor.utils.ComponentUtil;
	import editor.utils.VOUtil;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	public class AddTemplateCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * @param $id:String 当被选择页面为空时，$id是布局id;否则，$id是被选页面的父级id。
		 * @param $templateID:String 模版id。
		 * @param $order:uint 顺序增量。
		 * 
		 */
		
		public function AddTemplateCommand($id:String, $templateID:String, $order:uint = 0, $revocable:Boolean = false)
		{
			 super();
			 
			 id        = $id;
			 order     = $order;
			 templateID= $templateID;
			 revocable = $revocable;
			 
			 url = RegexpUtil.replaceTag(URLConsts.URL_TEMPLATE_AMD, provider);
		}
		

		
		override protected function excuteCommand():void
		{
			if (selectedPage && selectedPage.parent)
			{
				communicate(JSON.stringify({"pageId" : id, "templateId" : templateID, "order" : order}), false);
			}
			else
			{
				communicate(JSON.stringify({"layoutId" : id, "templateId" : templateID, "order" : order}), false);
			}
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
		
		
		override protected function update($result:Object=null):void
		{
			if (url == RegexpUtil.replaceTag(URLConsts.URL_TEMPLATE_AMD, provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					for each (var $children:Object in $result.dataObjs)
					{
						returnPage($children, selectedPage ? selectedPage.parent : null);
					}
					
					vars.sheets.update();
				}
				else
				{
					Debugger.log("添加模版数据出错，此原因可能是服务端问题，请联系服务端管理员！");
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
		}
		
		
		/**
		 * 
		 * @param $page:Object 欲构建页面的数据。
		 * @param $parent:Page (default = null)
		 * 
		 */
		private function returnPage($page:Object, $parent:Page = null):void
		{
			var page:Page = VOUtil.createPage(
				$parent ? $parent.id : null,
				provider.layoutID, $page["order"], 
				$page["coordX"], $page["coordY"], 
				$page["width"], $page["height"], $page["label"]
			);
			
			page.id = $page["id"];
			page.background = $page["background"];

			if (!provider.program.home && $page["home"] == true) page.home = true;
			
			config.orders = provider.program.addPage(page, $parent, true);
			
			addPage();
			
			recoverComponents($page, page);
			
			for each (var child:Object in $page["pages"])
			{
				returnPage(child, page);
			}
		}
		
		
		/**
		 * @private
		 */
		private function recoverComponents($page:Object, page:Page):void
		{
			for each (var data:Object in $page["components"])
			{
				component = VOUtil.createComponent(page.id, data["componentTypeId"], data["order"], 
					ComponentUtil.reviseComponent(data["coordX"] - 45, page.width - 45),
					ComponentUtil.reviseComponent(data["coordY"] - 30, page.height - 30), 
					data["width"], data["height"], data["label"]);
				
				component.componentType = data["componentTypeId"] > 8    //特别处理的原因是删除了党政组件，导致其后面组件类型id与数组索引不匹配。
					? provider.program.componentTypesArr[data["componentTypeId"] - 2]
				    : provider.program.componentTypesArr[data["componentTypeId"] - 1];
				
				component.id = data["id"];
				
				provider.program.addComponent(page as Sheet, component, true);
				
			}
		}
		
		
		/**
		 * @private
		 */
		private var selectedPage:Page = MDConfig.instance.selectedSheet as Page;
		
		/**
		 * @private
		 */
		private var component:Component;
		
		/**
		 * @private
		 */
		private var children:Page;
		
		/**
		 * @private
		 */
		private var id:String;
		
		/**
		 * @private
		 */
		private var order:uint;
		
		/**
		 * @private
		 */
		private var templateID:String;
		
		
	}
}
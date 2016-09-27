package editor.commands
{
	
	/**
	 * 
	 * 添加页面。
	 * 
	 */
	
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.utils.VOUtil;
	import editor.views.Debugger;
	import editor.vos.Page;
	
	
	public final class AddPageCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $parent:Page 父级页面。
		 * @param $order:uint 顺序。
		 * @param $homeExist:Boolean 是否检测首页存在与否，如果检测，则在首页存在的情况下，不创建页面，如果不检测，则创建页面。
		 * 
		 */
		
		public function AddPageCommand($parent:Page, $order:uint, $homeExist:Boolean)
		{
			super();
			
			parent = $parent;
			order  = $order;
			home   = $homeExist;
			
			url = RegexpUtil.replaceTag(URLConsts.URL_PAGE_AMD, provider);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (!home || (home && provider.program && !provider.program.home)) 
			{
				page = VOUtil.createPage(
					parent ? parent.id : null, 
					provider.layoutID, 
					order, 0, 0, 
					provider.defaultWidth,
					provider.defaultHeight
				);
				
				if (provider.program)
				{
					if (!provider.program.home)page.home = true;
				}
				
				var data:Object = JSON.parse(page.toJSON());
				
				//新页面不需要ID数据
				delete data.id;
				
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
			if ($result && $result.result == "success")
			{
				//update data
				page.id = $result.id;
				config.orders = provider.program.addPage(page, parent, true);
				
				//update view
				vars.sheets.update();
				
				//update layout title
				if (vars.titleBar && config.isLayoutOpened)
					vars.canvas.content.update();
				
				//set selected
				config.selectedSheet = page;
			}
			else
			{
				Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
			}
		}
		
		
		/**
		 * @private
		 */
		private var page:Page;
		
		/**
		 * @private
		 */
		private var parent:Page;
		
		/**
		 * @private
		 */
		private var order:uint;
		
		/**
		 * @private
		 */
		private var home:Boolean;
		
	}
}
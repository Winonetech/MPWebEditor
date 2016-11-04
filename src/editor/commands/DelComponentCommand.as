package editor.commands
{
	
	/**
	 * 
	 * 删除元素。
	 * 
	 */
	
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Sheet;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	
	public final class DelComponentCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $component:Component 要删除的组件。
		 * 
		 */
		
		public function DelComponentCommand($component:Component, $revocable:Boolean = true)
		{
			super();
			
			sheet = config.editingSheet;
			component = $component;   
			revocable = $revocable;
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_DEL, component), provider);
		}
		
		
		override protected function processUndo():void
		{
			var isPage:Boolean = !(!provider.program.pages[component.sheetID]);
			
			url = RegexpUtil.replaceTag(
				  RegexpUtil.replaceTag(isPage 
					? URLConsts.URL_PAGE_COMPONENT_DEL_UNDO 
					: URLConsts.URL_AD_COMPONENT_DEL_UNDO,
					component), provider);

		
			method = "POST";
			var submits:Array = [];
			ArrayUtil.push(submits, {"id" : component.id});
			submits
			? communicate(JSON.stringify(submits), false)
				: commandEnd();
		}
		
		override protected function processRedo():void
		{
			presenter.execute(new DelComponentCommand(component, false));
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if (revocable)
				Alert.show("确定删除 " + component.label + " 吗？", "提示",
					Alert.OK|Alert.CANCEL, null,
					function(e:CloseEvent):void {
						e.detail == Alert.OK ? communicate(null, false) : commandEnd();
				});
			else communicate(null, false);
		}
		
		
		
		/**
		 * 
		 * 与后台通讯，改变组件的顺序
		 * 
		 */
		private function ordComponent():void
		{
			url    = RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_ORD, provider);
			method = "POST";
			
			var orders:Array = config.orders;
		
			config.orders = null;
			
			var submits:Array, child:Component;
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
			if (url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_DEL, component), provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					
					//update data
					config.orders = provider.program.delComponent(sheet, component);
					
					ordComponent();
					//update view
					vars.canvas.updateComponent(component, 2);
					vars.components.update();
					
					//clear selected
					if (config.selectedComponent == component)
						config.selectedComponent = null;
					
				}
				else
				{
					Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
				}
			}
			else if (url == RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_ORD, provider))
			{
				if ($result == "ok")
				{
					if (vars.components)
						vars.components.update();
					if (vars.canvas)
						vars.canvas.update();
				}
				else
				{
					Debugger.log("修改顺序出错");
				}
			}
			else if (url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_PAGE_COMPONENT_DEL_UNDO, component), provider) 
				  || url == RegexpUtil.replaceTag(RegexpUtil.replaceTag(URLConsts.URL_AD_COMPONENT_DEL_UNDO, component), provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == 2)
				{
					config.orders = provider.program.addComponent(
						provider.program.sheets[component.sheetID], component, true); 
					ordComponent();
					//update view
					vars.canvas.updateComponent(component, 1);
					vars.components.update();
					
					//clear selected
					if (config.selectedComponent == component)
						config.selectedComponent = null;
				}
				else
				{
					Debugger.log("撤销删除组件出错");
				}
			}
			
			
		}
		
		
		/**
		 * @private
		 */
		private var sheet:Sheet;
		
		/**
		 * @private
		 */
		private var component:Component;
		
	}
}
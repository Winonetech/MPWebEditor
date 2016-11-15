package editor.commands
{
	
	/**
	 * 
	 * 添加组件。
	 * 
	 */
	
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.core.MDConfig;
	import editor.core.ed;
	import editor.utils.ComponentUtil;
	import editor.utils.VOUtil;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.ComponentType;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	
	public final class AddComponentCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * @param $sheet:Sheet 要操作的版面，版面包含页面和广告。
		 * @param $componentType:ComponentType 组件类别。
		 * @param $order:uint 顺序。
		 * @param $x:Number X坐标。
		 * @param $y:Number Y坐标。
		 * 
		 */
		
		public function AddComponentCommand($sheet:Sheet, $componentType:ComponentType, $order:uint, $x:Number, $y:Number)
		{
			super();
			
			sheet         = $sheet;
			componentType = $componentType;
			x = $x;
			y = $y;
			order = $order;
			
			url = RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_AMD, provider);
		}

		override protected function processUndo():void
		{
			presenter.execute(new DelComponentCommand(component, false));
		}
		
		override protected function processRedo():void
		{
			var isPage:Boolean = !(!provider.program.pages[component.sheetID]);
			url = RegexpUtil.replaceTag(isPage
				? URLConsts.URL_PAGE_COMPONENT_DEL_UNDO 
				: URLConsts.URL_AD_COMPONENT_DEL_UNDO, provider);
			method = "POST";
			communicate(JSON.stringify({"pageId":sheet.id, "ids":[component.id]}));
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			component = VOUtil.createComponent(sheet.id, componentType.id, order, ComponentUtil.reviseComponent(x - 45,
				MDConfig.instance.editingSheet.width - 45),ComponentUtil.reviseComponent(y - 30,
				MDConfig.instance.editingSheet.height - 30));
			component.componentType = componentType;
			config.selectedSheet = null;
			var data:Object = JSON.parse(component.toJSON());
			
			delete data.id;
			
			communicate(JSON.stringify(data));
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			if(url == RegexpUtil.replaceTag(URLConsts.URL_COMPONENT_AMD, provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					//update data
					component.id = $result.id;
					component.componentType = componentType;
					provider.program.addComponent(sheet, component, true);
					
					//update view
					vars.canvas.updateComponent(component, 1);
					vars.components.update();
					
					//set selected
					config.selectedComponent = component;
				}
				else
				{
					Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
				}
			}
			else if(url == RegexpUtil.replaceTag(URLConsts.URL_PAGE_COMPONENT_DEL_UNDO, provider) 
				 || url == RegexpUtil.replaceTag(URLConsts.URL_AD_COMPONENT_DEL_UNDO  , provider))
			{
				if($result is String) $result = JSON.parse($result as String);
				if($result.result == 2)
				{
					provider.program.addComponent(sheet, component, true);
					vars.canvas.updateComponent(component, 1);
					vars.components.update();
				}
				else
				{
					Debugger.log("添加已撤销组件出错");
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
		
		/**
		 * @private
		 */
		private var componentType:ComponentType;
		
		/**
		 * @private
		 */
		private var x:Number;
		
		/**
		 * @private
		 */
		private var y:Number;
		
		/**
		 * @private
		 */
		private var order:uint;
		
	}
}
package editor.commands
{
	/**
	 * 
	 * 删除当前编辑页面的所有组件 
	 * 
	 * 
	 */
	
	import cn.mvc.collections.Map;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Page;
	import editor.vos.Sheet;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.events.CloseEvent;
	
	public class DelAllComponentCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 * 
		 * @param $sheet:Sheet 当前正在编辑页面。
		 * 
		 */
		
		public function DelAllComponentCommand($sheet:Sheet)
		{
			super();
			
			sheet  = config.editingSheet;
			
			method = "GET";
			
			url = RegexpUtil.replaceTag(
				RegexpUtil.replaceTag(
				(sheet is Page) 
				? URLConsts.URL_PAGE_DAC 
				: URLConsts.URL_AD_DAC, sheet), provider);
		}
		
		
		override protected function processUndo():void
		{
			url = RegexpUtil.replaceTag((sheet is Page) 
				? URLConsts.URL_PAGE_COMPONENT_DEL_UNDO 
				: URLConsts.URL_AD_COMPONENT_DEL_UNDO, provider);
			
			method = "POST";
			
			arrComponentId.length != 0
				? communicate(JSON.stringify({"pageId":sheet.id, "ids": arrComponentId}), false)
				: commandEnd();
		}
		
		
		override protected function processRedo():void
		{
			presenter.execute(new DelAllComponentCommand(sheet));
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			(sheet && sheet.componentsArr.length != 0) ? communicate() : commandEnd();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function update($result:Object = null):void
		{
			if (url == RegexpUtil.replaceTag(RegexpUtil.replaceTag((sheet is Page) 
					? URLConsts.URL_PAGE_DAC : URLConsts.URL_AD_DAC, sheet), provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == "success")
				{
					for (var temp:String in sheet.componentsMap) arrComponentId.push(temp);
					arr4backup = sheet.componentsArr.concat();
					
					provider.program.delAllComponent(sheet);
					
					if (vars.components)
						vars.components.delAllUpdate();
					
					if (vars.canvas)
						vars.canvas.update();
					
					config.selectedComponent = null;
					
				}
				else
				{
					Debugger.log("添加页面数据出错，此原因可能是服务端问题，请联系服务端管理员！");
				}
			}
			else if (url == RegexpUtil.replaceTag((sheet is Page) 
				? URLConsts.URL_PAGE_COMPONENT_DEL_UNDO 
				: URLConsts.URL_AD_COMPONENT_DEL_UNDO, provider))
			{
				if ($result is String) $result = JSON.parse($result as String);
				if ($result.result == 2)
				{
					var l:int = arr4backup.length;	
					for (var i:uint = 0; i < l; i++)
					{
						provider.program.addComponent(sheet, arr4backup[i], true);
						vars.components.updateView(arr4backup[i]);
					}
						vars.canvas.update();
//						vars.components.update();
					
				}
			}
			
		}
		
		
		/**
		 * @private 
		 */
		private var sheet:Sheet;
		
		private var arrComponentId:Array = [];
		
		private var arr4backup:Array;
	}
}
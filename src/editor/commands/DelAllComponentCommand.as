package editor.commands
{
	/**
	 * 
	 * 删除当前编辑页面的所有组件 
	 * 
	 * 
	 */
	
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
			
			method = "GEt";
			
			
			var submits:Array = [];
			ArrayUtil.push(submits, {"ids" : ""});
			submits
			? communicate(JSON.stringify(submits), false)
				: commandEnd();
		}
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			if(sheet && sheet.componentsArr.length != 0)
			{
				Alert.show("确定删除  " + sheet.label + "  的所有组件吗？", "提示",
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
		
		
		/**
		 * @private 
		 */
		private var sheet:Sheet;
	}
}
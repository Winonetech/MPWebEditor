package editor.commands
{

	/**
	 * 
	 * 保存数据。
	 * 
	 */
	
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.core.MDConfig;
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.Debugger;
	import editor.views.PageSelector;
	import editor.vos.Component;
	import editor.vos.PLayout;
	import editor.vos.Page;
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class SaveTemplateDataCommand extends _InternalCommCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function SaveTemplateDataCommand()
		{
			super();
			
			revocable = false;
			
			method = "POST";
			
			url = RegexpUtil.replaceTag(URLConsts.URL_LAYOUT_SAVETEMPLATE, provider);
		}
		
		
		override protected function excuteCommand():void
		{
			const name:String = MDConfig.instance.templateName;
			
//			for each (var component:Component in program.components)
//			component.id = null;
			
//			for each (var $page:Page in program.pages) 
//			$page.id = null;

			for each (var $child:Page in program.children)
			{
				arr.push(JSON.parse($child.toJSON())); //解析后会有\，其为转义符
			}
			
			var submits:Array = [];
			ArrayUtil.push(submits, {"template" : arr, "name" : name});
			
			submits
			? communicate(JSON.stringify(submits))
			: commandEnd();	
		}
		
		
		
		/**
		 * @private
		 */
		private var program:PLayout = MDProvider.instance.program;
		
		/**
		 * @privates
		 */
		private var arr:Array = [];
		
	}
}
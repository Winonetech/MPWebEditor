package editor.commands
{

	/**
	 * 
	 * 保存数据。
	 * 
	 */
	
	import cn.mvc.utils.RegexpUtil;
	
	import editor.consts.URLConsts;
	import editor.views.Debugger;
	import editor.vos.Component;
	import editor.vos.Page;
	
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
		
		
		override public function execute():void
		{
			commandStart();
			
			excuteCommand();
			
			commandEnd();
		}
		
		override protected function excuteCommand():void
		{
			page = config.editingSheet as Page;
			
			var data:Object = JSON.parse(page.toJSON());
			
			data["template"] = true;

			delete data.id;
			delete data.layout;
			
			communicate(JSON.stringify(data));
		}
		
		
		/**
		 * @private 
		 */
		private var page:Page;
	}
}
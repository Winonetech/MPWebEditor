package editor.commands
{
	
	/**
	 * 
	 * 初始化环境。
	 * 
	 */
	
	
	import editor.utils.CommandUtil;
	
	import flash.system.Security;
	
	import mx.controls.Alert;
	
	import w11k.flash.AngularJSAdapter;
	
	
	public final class InitEnvironmentCommand extends _InternalCommand
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function InitEnvironmentCommand()
		{
			super();
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override protected function excuteCommand():void
		{
			//安全沙箱
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			//提示标签
			Alert.okLabel = "确定";
			Alert.cancelLabel = "取消";
			
			//注册JS调用函数
			var adapter:AngularJSAdapter = AngularJSAdapter.getInstance();
			vars.adapter = adapter;
			
			adapter.expose("templateId", CommandUtil.openTemplate);
			adapter.expose("presetTemplateId", CommandUtil.openPresetTemplate);
			adapter.expose("transmitData", CommandUtil.transmitData);
			adapter.expose("fillComplete", CommandUtil.fillComplete);
			adapter.expose("getSheetBackground", CommandUtil.getSheetBackground);
			//通知浏览器flash准备完毕
			adapter.fireFlashReady();
		}
		
	}
}
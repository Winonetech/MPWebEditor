package editor.views
{
	
	/**
	 * 
	 * 视图基类。
	 * 
	 */
	
	
	import editor.core.MDConfig;
	import editor.core.MDVars;
	
	import spark.components.Group;
	
	
	public class _InternalView extends Group
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalView()
		{
			super();
		}
		
		
		/**
		 * 
		 * 配置文件。
		 * 
		 */
		
		protected function get config():MDConfig
		{
			return MDConfig.instance;
		}
		
	}
}
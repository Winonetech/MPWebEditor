package editor.vos
{
	
	/**
	 * 
	 * 数据结构基类。
	 * 
	 */
	
	
	import cn.mvc.datas.VO;
	import cn.mvc.utils.IDUtil;
	
	import editor.core.MDConfig;
	
	
	internal class _InternalVO extends VO
	{
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function _InternalVO($data:Object = null, $name:String = "multipublish")
		{
			super($data, $name);
			
			if (id) IDUtil.generateID(rootNodeName);
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
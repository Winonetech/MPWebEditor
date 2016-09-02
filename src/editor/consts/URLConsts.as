package editor.consts
{
	
	import cn.mvc.consts.Consts;
	
	
	public final class URLConsts extends Consts
	{
		
		/**
		 * 
		 * 应用布局地址。
		 * 
		 */
		
		public static const URL_LAYOUT_APPLY:String = "{domain}/layout/apply/{programID}/{layoutID}";
		
		
		/**
		 * 
		 * 获取布局地址。
		 * 
		 */
		
		public static const URL_LAYOUT:String = "{domain}/layout/{layoutID}";
		
		
		/**
		 * 
		 * 添加修改页面地址。
		 * 
		 */
		
		public static const URL_PAGE_AMD:String = "{domain}/page";
		
		
		/**
		 * 
		 * 删除页面地址。
		 * 
		 */
		
		public static const URL_PAGE_DEL:String = "{domain}/page/del/{id}";
		
		
		/**
		 * 
		 * 修改页面顺序地址。
		 * 
		 */
		
		public static const URL_PAGE_ORD:String = "{domain}/page/update/orderIndex";
		
		
		/**
		 * 
		 * 修改广告地址。
		 * 
		 */
		
		public static const URL_AD_MOD:String = "{domain}/ad";
		
		
		/**
		 * 
		 * 添加修改组件地址。
		 * 
		 */
		
		public static const URL_COMPONENT_AMD:String = "{domain}/component";
		
		
		/**
		 * 
		 * 删除组件地址。
		 * 
		 */
		
		public static const URL_COMPONENT_DEL:String = "{domain}/component/del/{id}";
		
		
		/**
		 * 
		 * 修改组件顺序地址。
		 * 
		 */
		
		public static const URL_COMPONENT_ORD:String = "{domain}/component/update/orderIndex";
		
	}
}
package editor.consts
{
	
	import cn.mvc.consts.Consts;
	
	import editor.core.MDConfig;
	
	
	public final class URLConsts extends Consts
	{
		
		/**
		 * 
		 * 应用布局地址。
		 * 
		 */
		
		public static const URL_LAYOUT_APPLY:String = "{domain}/layout/apply/{programID}/{layoutID}/{userName}";
		
		
		/**
		 * 
		 * 获取布局地址。
		 * 
		 */
		
		public static const URL_LAYOUT:String = MDConfig.instance.mode == "fill" 
			? "{domain}/layout/{publishID}/{layoutID}" : "{domain}/layout/{layoutID}";
		
		
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
		 * 当前正在编辑页面的地址 
		 * 
		 */
		public static const URL_PAGE_DAC:String = "{domain}/page/empty/{id}";
		
		
		/**
		 * 
		 * 当前正在编辑广告的地址 
		 * 
		 */
		public static const URL_AD_DAC:String = "{domain}/ad/empty/{id}";
		
		
		/**
		 * 
		 * 修改组件顺序地址。
		 * 
		 */
		
		public static const URL_COMPONENT_ORD:String = "{domain}/component/update/orderIndex";
		
		/**
		 * 
		 * 撤销删除组件地址。
		 * 
		 */
		
		public static const URL_COMPONENT_DEL_UNDO:String = "{domain}/page/recoveryDelComponent/{sheetID}";
		
	}
}
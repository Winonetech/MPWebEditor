package editor.consts
{
	
	import cn.mvc.consts.Consts;
	
	import mx.collections.ArrayCollection;
	
	
	public final class DataConsts extends Consts
	{
		
		/**
		 * 
		 * 数据用例。
		 * 
		 */
		
		public static const PROGRAM:Object = 
		{
//			domain:"http://172.16.0.60:9000/layout",
//			domain:"http://192.168.7.3:9000/layout", 
//			domain:"http://172.16.1.4:9002/layout",   
			domain:"http://172.16.1.4:9000/layout",   
//			domain:"http://172.16.0.17:9000/layout",   
//			domain:"http://172.16.0.17:9000/content/publish",   
//			domain:"http://172.16.1.4:9000/content/publish",   
			programId: 25,
			layoutId:  2,
//			publishId: 2,
			programName: "滑稽",
			defaultWidth: "1920",
			defaultHeight: "1080",
			userName:"YuanZhang",
			mode:"edit"
		};
		
		
		/**
		 * 
		 * 组件过渡属性数据源。
		 * 
		 */
		
		public static const TRANSITION_DIRECTIONS:ArrayCollection = new ArrayCollection
		([{
			"label" : "左右滑动", 
			"value" : "leftRight"
		}, 
		{
			"label" : "上下滑动", 
			"value" : "upDown"
		}]);
	}
}
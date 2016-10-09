package editor.utils
{
	import mx.collections.ArrayCollection;
	
	import spark.components.HGroup;
	
	import cn.mvc.core.NoInstance;
	
	import editor.core.MDProvider;
	import editor.core.MDVars;
	import editor.views.Debugger;
	import editor.views.tabs.TitleBar;
	import editor.views.tabs.TitleTab;
	import editor.vos.Sheet;
	
	public final class TabUtil extends NoInstance
	{
		public static function sheet2Tab($sheet:Sheet):TitleTab
		{
			var temp:TitleTab;
			for (var i:int = 1; i < HG.numElements; i++)
			{
				temp = HG.getElementAt(i) as TitleTab;
				if ($sheet.id == idObj[temp.uid])
				{
					return temp; 
				}
			}
			
			for (var j:int; j < dataArrs.length; j++)
			{
				temp = dataArrs[j];
				if ($sheet.id == idObj[temp.uid])
				{
					return temp;
				}
			}
			return null;
		}
		
		public static function tab2Sheet($tab:TitleTab):Sheet
		{
			return MDProvider.instance.program.sheets[idObj[$tab.uid]];
		}
		
		/**
		 * @private
		 */
		public static function addTitle(sheet:Sheet):void
		{
			if (repeatById(sheet.id))
			{
				var title:TitleTab = new TitleTab;
				var temp:TitleTab = HG.addElement(title) as TitleTab;
				idObj[temp.uid] = sheet.id;
			}
			titleBar.selected = TabUtil.sheet2Tab(sheet);
		}
		
		public static function repeatById($id:String):Boolean
		{
			for each (var id:String in idObj)
			if (id == $id) return false;
			return true;
		}
		
		public static function repeatByTab($tab:TitleTab):Boolean
		{
			for each (var tab:TitleTab in dataArrs)
			if (tab == $tab) return false;
			return true;	
		}
		
		private static function get HG():HGroup
		{
			return titleBar.HG;
		}
		
		private static function get dataArrs():ArrayCollection
		{
			return titleBar.dataArrs;
		}
		
		private static function get idObj():Object
		{
			return titleBar.idObj;
		}
		
		private static var titleBar:TitleBar = MDVars.instance.titleBar;
		
	}
}
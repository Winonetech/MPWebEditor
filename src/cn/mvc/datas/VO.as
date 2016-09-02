package cn.mvc.datas
{
	
	import cn.mvc.core.MCEventDispatcher;
	import cn.mvc.core.vs;
	import cn.mvc.utils.JSONUtil;
	import cn.mvc.utils.ObjectUtil;
	import cn.mvc.utils.StringUtil;
	import cn.mvc.utils.XMLUtil;
	
	import flash.events.IEventDispatcher;
	
	
	public class VO extends MCEventDispatcher
	{
		
		
		/**
		 * 
		 * 构造函数。
		 * 
		 */
		
		public function VO($data:Object = null, $name:String = "vo")
		{
			super();
			
			initialize($data, $name);
		}
		
		
		/**
		 * 
		 * 解析转换数据。
		 * 
		 */
		
		public function parse($data:Object):void
		{
			if ($data)
			{
				vs::raw = $data;
				if ($data is String)
				{
					var src:String = StringUtil.trim(String($data));
					data = ObjectUtil.convert(JSONUtil.validate(src) ? src : XML(src), Object);
				}
				else
				{
					data = ObjectUtil.convert($data, Object);
				}
			}
			else data = {};
		}
		
		
		/**
		 * 
		 * XML格式缓存数据。
		 * 
		 */
		
		public function toXML():String
		{
			return ObjectUtil.convert(data, XML, rootNodeName).toString();
		}
		
		
		/**
		 * 
		 * json格式缓存数据。
		 * 
		 */
		
		public function toJSON():String
		{
			return JSON.stringify(data);
		}
		
		
		/**
		 * 初始化操作。
		 * @private
		 */
		private function initialize($data:Object, $name:String):void
		{
			rootNodeName = $name;
			disc = {};
			parse($data);
		}
		
		
		/**
		 * 
		 * 获取属性。
		 * 
		 * @param $name:String 属性名称。
		 * @param $type:Class 数据类型。
		 * @param $qualified:Boolean 是否获取完全限定名。
		 * 
		 * @return * 属性值。
		 * 
		 */
		
		protected function getProperty($name:String, $type:Class = null, $qualified:Boolean = false):*
		{
			return disc[$name] || (disc[$name] = ObjectUtil.convert(data[$name], $type));
		}
		
		
		/**
		 * 
		 * 设置属性。
		 * 
		 * @param $name:String 属性名称。
		 * @param $value:* 属性值。
		 * 
		 */
		
		protected function setProperty($name:String, $value:*):void
		{
			data[$name] = $value;
			delete disc[$name];
		}
		
		
		/**
		 * 
		 * id
		 * 
		 */
		
		public function get id():String
		{
			return getProperty("id");
		}
		
		/**
		 * @private
		 */
		public function set id($id:String):void
		{
			setProperty("id", $id);
		}
		
		
		/**
		 * 
		 * 原始数据。
		 * 
		 */
		
		public function get raw():*
		{
			return vs::raw;
		}
		
		
		/**
		 * 
		 * 存储原始数据。
		 * 
		 */
		
		protected var data:Object;
		
		
		/**
		 * 
		 * 存储转换后的数据。
		 * 
		 */
		
		protected var disc:Object;
		
		
		/**
		 * 
		 * 名称
		 * 
		 */
		
		protected var rootNodeName:String = "vo";
		
		
		/**
		 * 存储关联数据结构。
		 * @private
		 */
		private var rela:Object;
		
		
		/**
		 * @private
		 */
		vs var raw:*;
		
	}
}
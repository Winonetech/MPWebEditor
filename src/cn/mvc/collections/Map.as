package cn.mvc.collections
{
	
	/**
	 * 
	 * 扩展的Object类，与Object用法相同，增加了length属性。
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	
	
	import cn.mvc.core.vs;
	import cn.mvc.interfaces.IID;
	import cn.mvc.interfaces.ILength;
	import cn.mvc.interfaces.IName;
	import cn.mvc.utils.ArrayUtil;
	import cn.mvc.utils.ClassUtil;
	import cn.mvc.utils.IDUtil;
	import cn.mvc.utils.StringUtil;
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	
	[Bindable]
	public dynamic class Map extends Proxy implements ILength, IID, IName
	{
		
		/**
		 * 
		 * <code>Map</code>构造函数。
		 * 
		 */
		
		public function Map()
		{
			super();
			
			initialize();
		}
		
		
		/**
		 * 
		 * 清空字典。
		 * 
		 */
		
		public function clear():void
		{
			itemObject = {};
			itemNameArray.length = 0;
			nameIndexObject = {};
			itemIndexDictionary = new Dictionary;
			vs::length = 0;
		}
		
		
		/**
		 * 
		 * 对自身的一个拷贝。
		 * 
		 */
		
		public function clone():Map
		{
			var map:Map = new Map, key:String;
			for (key in this) map[key] = this[key];
			return map;
		}
		
		
		/**
		 * 
		 * 对自身的一个拷贝。
		 * 
		 */
		
		public function toArray():Array
		{
			var result:Array = [], item:*;
			for each (item in this) ArrayUtil.push(result, item);
			return result;
		}
		
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			itemObject = {};
			itemNameArray = [];
			nameIndexObject = {};
			itemIndexDictionary = new Dictionary;
			
			vs::id = IDUtil.generateID();
		}
		
		
		/**
		 * 
		 * 重写调用属性或方法的行为。
		 * 
		 * @param $name 方法或属性的名字
		 * @param ...rest 如果是方法，则代表了该方法的参数。
		 * @return 方法或属性的返回。
		 * 
		 */
		
		override flash_proxy function callProperty($name:*, ...$args):*
		{
			var result:*;
			$name = StringUtil.toString($name);
			if (itemObject[$name] is Function) 
				result = itemObject[$name].apply(itemObject, $args);
			
			return result;
		}
		
		
		/**
		 * 
		 * delete操作会调用该函数。
		 * 
		 * @param $name 标识名称。
		 * @return 如果被删除，则返回true，否则为false。
		 * 
		 */
		
		override flash_proxy function deleteProperty($name:*):Boolean
		{
			//defines some variables
			var order:int, index:uint, indexObj:*, name:String, value:*, i:uint;
			$name = StringUtil.toString($name);
			//check if itemObject[$name] exists
			if (itemObject[$name] != undefined) 
			{
				//subtract length.
				vs::length -= 1;
				//get the index of itemObject[name] from nameIndexObject by name.
				index = nameIndexObject[$name];
				//store in itemIndexDictionary, may be array or uint.
				indexObj = itemIndexDictionary[itemObject[$name]];
				//may be in the map has two or more same element, 
				//then the indexObj is an array stores sane element, 
				//need to check the indexObj type.
				if (indexObj is Array) 
				{
					//the indexObj is an array, means that has same elements.
					//get the index order from indexObj
					order = indexObj.indexOf(index);
					//delete the index from indexObj
					indexObj.splice(order, 1);
					//if only one left, stores uint in itemIndexDictionary. 
					if (indexObj.length== 1) 
						itemIndexDictionary[itemObject[$name]] = indexObj[0];
					
				} 
				else 
				{
					//indexObj is an uint, means only one element the map stores, 
					//delete the index for old element doesn't exist in map anymore.
					delete itemIndexDictionary[itemObject[$name]];
				}
				//delete name record from itemNameArray.
				itemNameArray.splice(index, 1);
				//delete index record from nameIndexObject.
				delete nameIndexObject[$name];
				//subtract 1 for all records from index
				for (i = index; i < length; i++) 
				{
					//name of current element
					name = itemNameArray[i];
					//element
					value = itemObject[name];
					//get element indexObj
					indexObj = itemIndexDictionary[value];
					//check indexObj type
					if (indexObj is Array) 
					{
						//the indexObj is an array, means that has same elements.
						//get the index order from indexObj
						order = indexObj.indexOf(i);
						//subtract indexObj[order]
						indexObj[order] = i;
					} 
					else 
					{
						//indexObj is an uint, means only one element the map stores.
						//subtract indexObj
						indexObj = i;
					}
					//subtract the name index
					nameIndexObject[name] = i;
				}
			}
			return delete itemObject[$name];
		}
		
		
		/**
		 * When the descendant operator is used, this method is invoked. 
		 * <p>
		 * map..name
		 * 
		 * @param $name The name of the property to descend into the object and search for. 
		 * 
		 * @return The results of the descendant operator. 
		 */
		
		override flash_proxy function getDescendants($name:*):*
		{
			return itemObject[StringUtil.toString($name)];
		}
		
		
		/**
		 * If the property can't be found, the method returns undefined. For more 
		 * information on this behavior, see the ECMA-262 Language Specification, 
		 * 3rd Edition, section 8.6.2.1. 
		 * 
		 * @param $name The name of the property to retrieve. 
		 * 
		 * @return The specified property or undefined if the property is not found. 
		 */
		
		override flash_proxy function getProperty($name:*):*
		{
			return itemObject ? itemObject[StringUtil.toString($name)] : null;
		}
		
		
		/**
		 * Check whether an object has a particular property by name. 
		 * 
		 * @param $name The name of the property to check for. 
		 * 
		 * @return If the property exists, true; otherwise false. 
		 */
		
		override flash_proxy function hasProperty($name:*):Boolean
		{
			return(StringUtil.toString($name) in itemObject);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		override flash_proxy function isAttribute($name:*):Boolean
		{
			return super.flash_proxy::isAttribute(StringUtil.toString($name));;
		}
		
		
		/**
		 * Allows enumeration of the proxied object's properties by index number 
		 * to retrieve property names. This function supports implementing 
		 * for...in and for each..in loops on the object to retrieve the desired 
		 * names. 
		 * 
		 * @param $index The zero-based index value of the object's property. 
		 * 
		 * @return The property's name. 
		 */
		
		override flash_proxy function nextName($index:int):String
		{
			return itemNameArray[$index-1];
		}
		
		
		/**
		 * Allows enumeration of the proxied object's properties 
		 * by index number. This function supports implementing 
		 * for...in and for each..in loops on the object to 
		 * retrieve property index values. 
		 * 
		 * @param $index The zero-based index value where the enumeration begins. 
		 * 
		 * @return The property's index value. 
		 */
		
		override flash_proxy function nextNameIndex($index:int):int
		{
			return ($index < itemNameArray.length) ? $index + 1 : 0;
		}
		
		
		/**
		 * Allows enumeration of the proxied object's properties 
		 * by index number to retrieve property values. This 
		 * function supports implementing for...in and for each..in 
		 * loops on the object to retrieve the desired values. 
		 * 
		 * @param $index The zero-based index value of the object's property. 
		 * 
		 * @return The property's value. 
		 */
		
		override flash_proxy function nextValue($index:int):*
		{
			return itemObject[itemNameArray[$index-1]];
		}
		
		
		/**
		 * Overrides a call to change a property's value. If the 
		 * property can't be found, this method creates a property 
		 * with the specified name and value, store element 
		 * with [] and = operator. 
		 * <p>
		 * map["name"] = value
		 * 
		 * @param $name The name of the property to modify. 
		 * @param $value The value to set the property to. 
		 */
		
		override flash_proxy function setProperty($name:*, $value:*):void
		{
			//defines the variables.
			//the element index
			//store in itemIndexDictionary, may be array or uint.
			var index:uint, indexObj:*;
			$name = StringUtil.toString($name);
			//check whether object[name] exists, 
			//then determin override the old or add new.
			if (itemObject[$name]!= undefined) 
			{
				//if object[name] exist
				//get the index of itemObject[name] from nameIndexObject by name.
				index = nameIndexObject[$name];
				//get the indexObj from itemIndexDictionary 
				indexObj = itemIndexDictionary[itemObject[$name]];
				//may be in the map has two or more same element, 
				//then the indexObj is an array stores sane element, 
				//need to check the indexObj type.
				if (indexObj is Array) 
				{
					//the indexObj is an array, means that has same elements.
					//get the index order from indexObj
					//delete the index from indexObj
					indexObj.splice(indexObj.indexOf(index), 1);
					//if only one left, stores uint in itemIndexDictionary. 
					if (indexObj.length== 1) 
						itemIndexDictionary[itemObject[$name]] = indexObj[0];
				}
				else
				{
					//indexObj is an uint, means only one element the map stores, 
					//delete the index for old element doesn't exist in map anymore.
					delete itemIndexDictionary[itemObject[$name]];
				}
				//store the index of value in dictionary
				itemIndexDictionary[$value] = index;
			}
			else
			{
				//itemObject[name] not exist
				//the new element index must be length
				index = length;
				//get the indexObj in itemIndexDictionary
				indexObj = itemIndexDictionary[$value];
				//check whether the indexObj exists, 
				//to store the index into an array or uint
				if (indexObj== undefined)
				{
					//indexObj not exist, store the new index directly.
					itemIndexDictionary[$value] = index;
				}
				else
				{
					//indexObj exist, then store the new index to indexObj, 
					//or make an array to store
					if (indexObj is Array) 
						indexObj.push(index);
					else
						itemIndexDictionary[$value] = [indexObj, index];
				}
				//store the name of value in array order by index
				itemNameArray[index] = $name;
				//override or add the index of value name in nameIndexObject
				nameIndexObject[$name] = index;
				//add length
				vs::length += 1;
			}
			//store value in object
			itemObject[$name] = $value;
		}
		
		
		/**
		 * 
		 * 检测是否包含某项。
		 * 
		 * @param $value:* 需要检测的项。
		 * 
		 * @return Boolean
		 * 
		 */
		public function contains($value:*):Boolean
		{
			return (itemIndexDictionary[$value] != undefined);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get className():String
		{
			return vs::className = vs::className || ClassUtil.getClassName(this);
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get vid():uint
		{
			return vs::vid;
		}
		
		/**
		 * @private
		 */
		public function get length():uint
		{
			return vs::length;
		}
		
		
		/**
		 * @inheritDoc
		 */
		
		public function get instanceName():String { return vs::name; }
		
		/**
		 * @private
		 */
		public function set instanceName($value:String):void
		{
			vs::name = $value;
		}
		
		
		/**
		 * @private
		 * Storage the item index in request by item.
		 */
		private var itemIndexDictionary:Dictionary;
		
		/**
		 * @private
		 * Storage the item name by order.
		 */
		private var itemNameArray:Array;
		
		/**
		 * @private
		 * Storage the item name index by item name.
		 */
		private var nameIndexObject:Object;
		
		/**
		 * @private
		 * Storage the items.
		 */
		private var itemObject:Object;
		
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var length:uint;
		
		/**
		 * @private
		 */
		vs var name:String;
		
		/**
		 * @private
		 */
		vs var id:uint;
		
	}
}
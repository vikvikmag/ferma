package model.items
{
	public class Plant
	{
		private var _type:String;
		private var _level:int;
		private var _litName:String;
		private var _serverId:int;
		
		public function Plant()
		{
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set level(value:int):void
		{
			_level = value;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set litName(value:String):void
		{
			_litName = value;
		}
		
		public function get litName():String
		{
			return _litName;
		}
		
		public function set serverId(value:int):void
		{
			_serverId = value;
		}
		
		public function get serverId():int
		{
			return _serverId;
		}
		
		public function clone():Plant
		{
			var plant:Plant = new Plant();
			plant.type = _type;
			plant.level = _level;
			plant.litName = _litName;
			plant.serverId = _serverId;
			return plant;
		}
	}
}
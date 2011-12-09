package model.items
{
	public class ImageProperty
	{
		private var _cx:int;
		private var _cy:int;
		private var _url:String;
		private var _name:String;
		
		public function ImageProperty()
		{
		}
		
		public function set cx(value:int):void
		{
			_cx = value;
		}
		
		public function get cx():int
		{
			return _cx;
		}
		
		public function set cy(value:int):void
		{
			_cy = value;
		}
		
		public function get cy():int
		{
			return _cy;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
	}
}
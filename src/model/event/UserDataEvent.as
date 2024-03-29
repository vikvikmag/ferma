package model.event
{
	import flash.events.Event;

	public class UserDataEvent extends Event
	{
		public static const UPDATE_USER_DATA:String = "updateUserData";
		public static const BEGIN_CROP_PLANT:String = "beginCropPlant";
		public static const END_CROP_PLANT:String = "endCropPlant";
		public static const PICK_UP_PLANT:String = "pickUpPlant";
		
		private var _data:Object;
		
		public function UserDataEvent(type:String, data:Object = null)
		{
			super(type, false, false);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new UserDataEvent(type, _data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
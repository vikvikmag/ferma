package controller
{
	import flash.events.EventDispatcher;
	
	import model.UserData;
	import model.book.PlantsBook;
	import model.event.UserDataEvent;
	import model.items.Plant;

	public class GameController extends EventDispatcher
	{
		private var _userData:UserData = new UserData();		
		
		private static var _instance:GameController;
		public static function get instance():GameController
		{
			if (_instance == null)
			{
				_instance = new GameController();
			}
			return _instance;
		}
		
		private var _countTime:int = 0;
		
		public function GameController()
		{
			addEventListener(UserDataEvent.CROP_PLANT, onCropPlant);
			addEventListener(UserDataEvent.PICK_UP_PLANT, onPickUpPlant);
		}
		
		public function get userData():UserData
		{
			return _userData;
		}
		
		public function parseUserData(xml:XML):void
		{
			for each(var node:XML in xml.plant)
			{
				var plant:Plant = PlantsBook.instance.getPlantByType(node.@type).clone();
				plant.level = node.@level;
				if (plant.level <= 0 || plant.level > 5)
				{
					throw new Error("Сервер нагло врёт! Уровень растений не может равняться :" + 
						String(plant.level));
				}
				plant.serverId = node.@id;
				plant.tileX = node.@x;
				plant.tileY = node.@y;
				_userData.addPlant(plant);
			}
			dispatchEvent(new UserDataEvent(UserDataEvent.UPDATE_USER_DATA));
		}
		
		private function tickTime():void
		{
			_countTime++;
			
			_userData.growUpAllPlants();
		}
		
		public function get countTime():int
		{
			return _countTime;
		}
		
		private function onCropPlant(event:UserDataEvent):void
		{
			var plant:Plant = (event.data as Plant).clone();
			plant.level = 1;
			_userData.addPlant(plant);
		}
		
		private function onPickUpPlant(event:UserDataEvent):void
		{
			var plant:Plant = event.data as Plant;
			_userData.removePlant(plant);
		}
	}
}
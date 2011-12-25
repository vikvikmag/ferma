package controller
{
	import flash.events.EventDispatcher;
	
	import model.UserData;
	import model.book.PlantsBook;
	import model.event.UserDataEvent;
	import model.farmGrid.FarmGrid;
	import model.items.Plant;

	public class GameController extends EventDispatcher
	{
		public static const VERSION:String = "build 1.2";
		
		private var _userData:UserData;
		private var _farmGrid:FarmGrid;
		
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
			_userData = new UserData();
			_farmGrid = new FarmGrid(_userData);
		}
		
		public function get userData():UserData
		{
			return _userData;
		}
		
		public function get farmGrid():FarmGrid
		{
			return _farmGrid;
		}
		
		public function parseUserData(xml:XML):void
		{
			for each(var node:XML in xml.plant)
			{
				var plant:Plant = PlantsBook.instance.getPlantByType(node.@type).clone();
				plant.level = node.@level;
				if (plant.level <= 0 || plant.level > 5)
				{
					throw new Error("Сервер нагло врёт! Уровень растений не может равняться: " + 
						String(plant.level));
				}
				plant.serverId = node.@id;
				plant.tileX = node.@x;
				plant.tileY = node.@y;
				_userData.addPlant(plant);
			}
			_farmGrid.update();
			dispatchEvent(new UserDataEvent(UserDataEvent.UPDATE_USER_DATA));
		}
		
		/**
		 *  Собрать растение
		 */ 
		public function pickUpPlant(plant:Plant):void
		{
			if (_userData.plants.indexOf(plant) != -1)
			{
				_userData.removePlant(plant);
				_farmGrid.update();
				dispatchEvent(new UserDataEvent(UserDataEvent.PICK_UP_PLANT, plant));
			}
			else
			{
				throw new Error("Попытка собрать растение, которого нет в юзерДате");
			}
		}
		
		public function beginCropPlant(plant:Plant):void
		{
			var cropPlant:Plant = plant.clone();
			cropPlant.level = 1;
			dispatchEvent(new UserDataEvent(UserDataEvent.BEGIN_CROP_PLANT, cropPlant));
		}
		
		public function endCropPlant(plant:Plant):void
		{
			_userData.addPlant(plant);
			_farmGrid.update();
			dispatchEvent(new UserDataEvent(UserDataEvent.UPDATE_USER_DATA));
		}
		
		public function tickTime():void
		{
			_countTime++;
			
			_userData.growUpAllPlants();
			dispatchEvent(new UserDataEvent(UserDataEvent.UPDATE_USER_DATA));
		}
		
		public function get countTime():int
		{
			return _countTime;
		}
	}
}
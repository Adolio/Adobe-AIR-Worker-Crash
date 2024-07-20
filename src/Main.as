package
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;

	public class Main extends Sprite
	{
		private var _serializer:AsyncObjectToJsonStringSerializer;

		public function Main()
		{
			_serializer = new AsyncObjectToJsonStringSerializer();
			_serializer.addEventListener(SerializationEvent.SERIALIZATION_COMPLETE, onComplete);
			_serializer.addEventListener(ErrorEvent.ERROR, onError);

			var object:Object = { fieldA: "Hello world", fieldB: 42, fieldC: "A pretty long string that should take two lines"};
			_serializer.serializeAsync(object, true, 40);
		}

		private function onComplete(event:SerializationEvent):void
		{
			trace("Serialization completed.\n\nResult:\n\n" + event.result);
		}

		private function onError(event:ErrorEvent):void
		{
			trace("Serialization failed. Error: " + event.errorID);
		}
	}
}
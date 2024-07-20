package
{
 	import flash.events.Event;

	public class SerializationEvent extends Event
	{
		public static const SERIALIZATION_COMPLETE:String = "serializationComplete";
		public var result:String;

		public function SerializationEvent(type:String, result:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}

		// always create a clone() method for events in case you want to redispatch them.
		public override function clone():Event
		{
			return new SerializationEvent(type, result, bubbles, cancelable);
		}
	}
}
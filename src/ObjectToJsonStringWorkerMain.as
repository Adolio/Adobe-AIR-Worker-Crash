package
{
	import com.maccherone.json.JSONEncoder;
	import flash.display.Sprite;
	import flash.system.MessageChannel;
	import flash.system.Worker;

	/**
	 * An asynchronous object to JSON string serializer worker.
	 */
	public class ObjectToJsonStringWorkerMain extends Sprite
	{
		private var _workerToMainChannel:MessageChannel;

		public function ObjectToJsonStringWorkerMain():void
		{
			// get params
			var object:Object = Worker.current.getSharedProperty("object");
			var pretty:Boolean = Worker.current.getSharedProperty("pretty");
			var maxLength:int = Worker.current.getSharedProperty("maxLength");

			if (maxLength <= 0)
				maxLength = 80;

			_workerToMainChannel = Worker.current.getSharedProperty("workerToMainChannel");

			try
			{
				// setup json encoder
				var jsonEncoder:JSONEncoder = new JSONEncoder(object, pretty, maxLength);

				// send completion message
				if (_workerToMainChannel)
					_workerToMainChannel.send(jsonEncoder.getString());
			}
			catch (e:Error)
			{
				// send completion error
				if (_workerToMainChannel)
					_workerToMainChannel.send(e);
			}
		}
	}
}
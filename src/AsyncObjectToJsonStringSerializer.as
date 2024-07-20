package
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.events.EventDispatcher;
	import flash.events.ErrorEvent;

	/**
	 * An asynchronous object to JSON string serializer.
	 */
	public class AsyncObjectToJsonStringSerializer extends EventDispatcher
	{
		// worker
		[Embed(source="../bin/ObjectToJsonStringWorker.swf", mimeType="application/octet-stream")] public static const ObjectToJsonStringWorker:Class;
		private var _worker:Worker;
		private var _workerToMainChannel:MessageChannel;

		public function serializeAsync(object:Object, pretty:Boolean, maxLength:int = 80):void
		{
			// create the background worker
			var workerBytes:ByteArray = new ObjectToJsonStringWorker();
			_worker = WorkerDomain.current.createWorker(workerBytes, true);

			// create communication channel
			_workerToMainChannel = _worker.createMessageChannel(Worker.current);
			_workerToMainChannel.addEventListener(Event.CHANNEL_MESSAGE, onMessagefromWorker);

			// setup worker params
			_worker.setSharedProperty("object", object);
			_worker.setSharedProperty("pretty", pretty);
			_worker.setSharedProperty("maxLength", maxLength);
			_worker.setSharedProperty("workerToMainChannel", _workerToMainChannel);

			_worker.start();
		}

		private function onMessagefromWorker(event:flash.events.Event):void
		{
			// done
			var result:* = _workerToMainChannel.receive();

			// disposing worker
			_workerToMainChannel.close();
			_workerToMainChannel = null;
			_worker.terminate(); // CRASH !!!
			_worker = null;

			// forward completion
			if (result is Error)
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			else
				dispatchEvent(new SerializationEvent(SerializationEvent.SERIALIZATION_COMPLETE, result));
		}

		public function dispose():void
		{
			// close channel
			if (_workerToMainChannel)
				_workerToMainChannel.close();

			// terminate worker
			if (_worker)
				_worker.terminate(); // CRASH !!!

			// nullify references
			_workerToMainChannel = null;
			_worker = null;
		}
	}
}